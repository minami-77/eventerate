class EventsController < ApplicationController
  before_action :skip_authorization, only: [:show, :preview_event_plan, :save_event_plan, :save_fake_event_plan]
  before_action :set_event, only: [:show, :edit, :update, :preview_event_plan, :save_event_plan, :regenerate_activities]

  # def index
  #   @events = policy_scope(Event).order(date: :asc)
  #   @event = Event.all
  #   @event = Event.new
  # end
  def show
    @event = Event.find(params[:id])
    @users = @event.organization.users
    # @activities = Activity.where(event_id: @event)
    @task = @event.tasks.new
    @suggestions = @task.content(@generated_activities)
    @collaborators = @event.collaborators
    @activities_events = ActivitiesEvent.where(event_id: @event)
  end

  def new
    @event = Event.new
    authorize @event
  end

  def create
    @event = Event.new(event_params)
    # @event.age_range = params[:event][:age_range]
    # @event.num_activities = params[:event][:num_activities]
    @event.user = current_user
    @event.organization = Organization.find(current_user.organization_users.first.organization_id)
    authorize @event
    # raise
    if @event.save
      Collaborator.create(event: @event, user: current_user)
      # Initializes a chat with the creator of the event to start off with
      ChatService.create_event_chat(@event, current_user)
      # @event.generate_activities
      # redirect_to @event, notice: 'Event was successfully created.'
      session[:age_range] = params[:event][:age_range]
      session[:num_activities] = params[:event][:num_activities]

      @event.generate_activities_from_ai(session[:age_range], session[:num_activities])
      redirect_to preview_event_plan_event_path(@event)
    else
      Rails.logger.info @event.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  # raise
  # def preview_event_plan
  #   raise
  #   # @event = Event.find(params[:id])
  #   authorize @event
  #   age_range = session[:age_range]
  #   num_activities = session[:num_activities].to_i

  #   Rails.logger.info "🔥 Calling AI with Age Range: #{age_range}, Num Activities: #{num_activities}"

  #   @generated_activities = @event.generate_activities_from_ai(age_range, num_activities)
  #   # Store activities that the user already selected
  #   @selected_activities = @event.activities
  #   # raise
  # end

  def preview_event_plan
    authorize @event
    age_range = session[:age_range]
    num_activities = session[:num_activities].to_i
    @task = @event.tasks.new

    @generated_activities = @event.generate_activities_from_ai(age_range, num_activities)
    @suggestions = @task.content(@generated_activities)
    Rails.logger.info "Task: #{@task.inspect}"
    Rails.logger.info "Generated Activities: #{@generated_activities.inspect}"
    Rails.logger.info " @suggestions #{@suggestions.inspect}"
  end

  def save_event_plan
    authorize @event
    all_activities = params[:activities] || []
    suggestions=JSON.parse(params[:suggestions])
    all_activities.each do |activity_data|
      activity = Activity.create!(
        title: activity_data["title"],
        description: activity_data["description"],
        genres: JSON.parse(activity_data["genres"]),
        age: activity_data["age"]
      )
      ActivitiesEvent.create!(activity: activity, event: @event)
    end
    flash[:notice] = "Event plan saved successfully!"
    # Delete when we have better task creation maybe
    if params[:tasks]
      params[:tasks].each do |key, activity|
        activity.each do |task|
          Task.create!(event: @event, title: task[" "])
        end
      end
    end

    suggestions.values.flatten.each do |suggestion|
      task = Task.new(title: suggestion.strip, completed: false, event: @event)
      authorize task
      task.save
    end

    redirect_to event_path(@event)
    authorize @event

    # # Save tasks
    # # Method to parse the suggestions string and return it as an array
    # def parse_suggestions(suggestions_data)
    #   # Removing extra characters and parsing the string into an array
    #   suggestions_data.gsub!(/\[|\]/, '')  # Remove square brackets
    #   suggestions_data.split(',')          # Split by comma to create an array
    # end

    # # Method to save the parsed suggestions as tasks
    # def save_suggestions_as_tasks(parsed_suggestions)
    #   parsed_suggestions.each do |suggestion|
    #     task = Task.new(title: suggestion.strip, completed: false, event: @event)
    #     authorize task
    #     task.save
    #   end
    # end
  end

  def regenerated_activities
    @event = Event.find(params["event_id"])
    authorize @event
    count = session[:num_activities].to_i
    ages = session[:age_range]

    selected_titles = params[:selected_activity_titles] || []
    @selected_activities = params[:activities].select { |activity| selected_titles.include?(activity["title"]) }

    remaining = count - @selected_activities.count
    if remaining > 0
      @generated_activities = @event.generate_activities_from_ai(ages, remaining)
    end
  end

  def edit
    @event = Event.find(params[:id])
    authorize @event
  end

  def update
    @event = Event.find(params[:id])
    authorize @event
    if @event.update(event_params)
      redirect_to event_path(@event)
    else
      render :show
    end
  end

  # Preview presentation
  def fake_preview
    @event = Event.new(event_params)
    @event.user = current_user
    @event.organization = current_user.organizations.first
    authorize @event
    Collaborator.create(event: @event, user: current_user)
    @event.save
    ChatService.create_event_chat(@event, current_user)
    @generated_activities = PreviewEventFluffService.get_initial_activities
    task_data = PreviewEventFluffService.get_initial_tasks

    @tasks = @generated_activities.each_with_object({}) do |activity, tasks_hash|
      tasks_hash[activity.title] = task_data[activity.title.to_sym] || []
    end
  end

  def fake_regenerated_preview
    @event = Event.last
    authorize @event
    @selected_activities = PreviewEventFluffService.get_saved_activities
    @generated_activities = PreviewEventFluffService.get_regenerated_activities
    @saved_tasks = PreviewEventFluffService.get_saved_tasks

    regenerated_titles = @generated_activities.map { |activity| activity["title"] }
    @regenerated_tasks = PreviewEventFluffService.get_regenerated_tasks.select { |key, _| regenerated_titles.include?(key.to_s) }
    @tasks = @regenerated_tasks.merge(PreviewEventFluffService.get_saved_tasks)
  end

  def save_fake_event_plan
    @event = Event.find(params[:event_id])
    authorize @event

    activities = params[:activities] || []

    activities.each do |activity_params|
      genres = activity_params[:genres].presence || []
      # Find or create the activity
      activity = Activity.create!(
        title: activity_params[:title],
        description: activity_params[:description],
        age: activity_params[:age],
        genres: genres
      )

      # Associate the activity with the event using the join table
      ActivitiesEvent.create!(
        event: @event,
        activity: activity,
        custom_title: activity_params[:custom_title],
        custom_description: activity_params[:custom_description]
      )

      # Save tasks directly under the event
      if activity_params[:tasks].present?
        activity_params[:tasks].each do |task_description|
          @event.tasks.create!(title: task_description, completed: false)
        end
      end
    end

    redirect_to event_path(@event), notice: 'Event plan saved successfully.'
  end

  private

  def event_params
    params.require(:event).permit(:title, :duration, :date, :num_activities, :age_range)
  end

  # def activity_params
  #   params.require(:activities_event).permit(:custom_title, :custom_description)
  # end

  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_event
    authorize @event
  end

end
