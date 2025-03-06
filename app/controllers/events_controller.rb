class EventsController < ApplicationController
  before_action :skip_authorization, only: [:show, :preview_event_plan, :save_event_plan, :save_fake_event_plan]
  before_action :set_event, only: [:show, :edit, :update, :preview_event_plan, :save_event_plan, :regenerate_activities]

  skip_after_action :verify_authorized, only: [:regenerate_activity]

  # def index
  #   @events = policy_scope(Event).order(date: :asc)
  #   @event = Event.all
  #   @event = Event.new
  # end
  def show
    @event = Event.find(params[:id])
    @users = @event.organization.users

    if @event.user == current_user
      # unassigned_tasks = @event.tasks.left_joins(:tasks_users).where(tasks_users: { id: nil })
      # assigned_tasks = @event.tasks.left_joins(:tasks_users).where.not(tasks_users: { id: nil })
      @tasks = @event.tasks.left_joins(:tasks_users).order(Arel.sql('CASE WHEN tasks_users.id IS NOT NULL THEN 0 ELSE 1 END'))
    else
      @tasks = @event.tasks.joins(:tasks_users).where(tasks_users: { user: current_user })
    end

    @task = @event.tasks.new
    @collaborators = @event.collaborators
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

  def regenerate_activity
    event_title = params["event_title"]
    age_range = params["age_range"]
    activity_title = params["activity_title"]
    @regenerated_activity = RegenerateActivityService.regenerate_activity(event_title, age_range, activity_title)
    render json: @regenerated_activity
  end

  def preview_event_plan
    authorize @event
    age_range = session[:age_range]
    num_activities = session[:num_activities].to_i
    @task = @event.tasks.new
    @org_users = current_user.organizations.first.users

    @generated_activities = @event.generate_activities_from_ai(age_range, num_activities)["activity"]
    @tasks = @task.content(@generated_activities)
    Rails.logger.info "Task: #{@task.inspect}"
    Rails.logger.info "Generated Activities: #{@generated_activities.inspect}"
    Rails.logger.info " @suggestions #{@suggestions.inspect}"
  end

  def save_event_plan
    @event = Event.find(params[:event_id])
    authorize @event

    activities = params[:activities] || []

    activities.each_with_index do |activity, index|
      user = nil
      if params["activity"]["#{index}"] != ""
        user = User.find(params["activity"]["#{index}"].to_i)
      end

      # Find or create the activity
      new_activity = @event.activities.create!(
        title: activity[:title],
        description: activity[:description],
        age: activity[:age],
        instructions: activity[:instructions],
        materials: activity[:materials]
      )

      # Associate the activity with the event using the join table

      # Save tasks directly under the event
      if activity[:tasks].present?
        activity[:tasks].each do |task_description|
          @task = @event.tasks.new(title: task_description, completed: false)
          @task.activity = new_activity
          @task.save
          @task.tasks_users.create!(user: user) if user
          if user && !@event.collaborators.find_by(user_id: user.id)
            @event.collaborators.create!(user: user)
          end
        end
      end
    end

    redirect_to event_path(@event), notice: 'Event plan saved successfully.'
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
    @event.save
    Collaborator.create(event: @event, user: current_user)
    ChatService.create_event_chat(@event, current_user)
    @generated_activities = PreviewEventFluffService.get_initial_activities
    @tasks = PreviewEventFluffService.get_initial_tasks
    @org_users = current_user.organizations.first.users
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

    activities.each_with_index do |activity, index|
      user = nil
      if params["activity"]["#{index}"] != ""
        user = User.find(params["activity"]["#{index}"].to_i)
      end

      genres = activity[:genres].presence || []
      # Find or create the activity
      new_activity = @event.activities.create!(
        title: activity[:title],
        description: activity[:description],
        age: activity[:age],
        instructions: activity[:instructions],
        materials: activity[:materials]
      )

      # Save tasks directly under the event
      if activity[:tasks].present?
        activity[:tasks].each do |task_description|
          @task = @event.tasks.new(title: task_description, completed: false)
          @task.activity = new_activity
          @task.save
          @task.tasks_users.create!(user: user) if user
          if user && !@event.collaborators.find_by(user_id: user.id)
            @event.collaborators.create!(user: user)
          end
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
