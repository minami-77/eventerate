class EventsController < ApplicationController
  before_action :skip_authorization, only: [:show, :preview_event_plan, :save_event_plan]
  before_action :set_event, only: [:show, :edit, :update, :preview_event_plan, :save_event_plan]

  # def index
  #   @events = policy_scope(Event).order(date: :asc)
  #   @event = Event.all
  #   @event = Event.new
  # end
  def show
    @event = Event.find(params[:id])
    @users = @event.organization.users
    @task = @event.tasks.new
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
      @event.collaborators.create(user: current_user)
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
  def preview_event_plan
    # @event = Event.find(params[:id])
    authorize @event
    age_range = session[:age_range]
    num_activities = session[:num_activities].to_i

    Rails.logger.info "🔥 Calling AI with Age Range: #{age_range}, Num Activities: #{num_activities}"

    @generated_activities = @event.generate_activities_from_ai(age_range, num_activities)
  end

  def save_event_plan
    # raise
    authorize @event
    # @generated_activities = @event.generate_activities_from_ai(session[:age_range], session[:num_activities])

    # if params[:activities].present?
    #   params[:activities].each do |activity_params|
    #     @event.activities.create(
    #       title: activity_params["title"],
    #       description: activity_params["description"],
    #       genres: JSON.parse(activity_params["genres"]), # Convert stringified array to real array
    #       age: activity_params["age"]
    #     )
    #   end
    #   flash[:notice] = "Event plan saved successfully!"
    # else
    #   flash[:alert] = "No activities to save."
    # end

    if params[:activities].present?
      params[:activities].each do |activity_params|
        activity = Activity.create(
          title: activity_params["title"],
          description: activity_params["description"],
          genres: JSON.parse(activity_params["genres"]), # Convert stringified array to real array
          age: activity_params["age"]
        )
        ActivitiesEvent.create(activity: activity, event: @event, custom_title: activity.title, custom_description: activity.description)
      end
      flash[:notice] = "Event plan saved successfully!"
    else
      flash[:alert] = "No activities to save."
    end

    redirect_to event_path(@event)
  end

  # def new_activity
  #   @event = Event.find(params[:id])
  #   @activity_event = ActivitiesEvent.new
  #   authorize @activity_event
  # end

  # def create_activity
  #   @event = Event.find(params[:id])
  #   @activity_event = ActivitiesEvent.new(activity_params)
  #   @activity_event.event = @event
  #   @activity_event.activity = Activity.first # the activity event must make a reference to an activity, otherwise it won't be saved. Any activity is fine.
  #   authorize @activity_event
  #   if @activity_event.save
  #     redirect_to @event, notice: 'Activity was successfully added.'
  #   else
  #     render :show, status: :unprocessable_entity
  #   end
  # end

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
