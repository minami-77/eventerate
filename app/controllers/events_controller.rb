class EventsController < ApplicationController
  before_action :skip_authorization, only: [:show, :preview_event_plan, :save_event_plan]
  before_action :set_event, only: [:show, :edit, :update, :preview_event_plan, :save_event_plan, :regenerate_activities]

  # def index
  #   @events = policy_scope(Event).order(date: :asc)
  #   @event = Event.all
  #   @event = Event.new
  # end
  def show
    @event = Event.find(params[:id])
    @users = User.all
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
    # Store activities that the user already selected
    @selected_activities = @event.activities
    # raise
  end

  # raise
  def regenerate_activities
    # Get the selected activity IDs from the params
    @event = Event.find(params[:event_id])
    selected_ids = params[:selected_activity_ids] || []

    # Retrieve num_activities from session
    num_activities = session[:num_activities].to_i

    # Regenerate activities for the ones that were not selected
    @event.regenerate_activities_except(selected_ids, num_activities)

    redirect_to preview_event_plan_event_path(@event)
  end

  def save_event_plan
    # raise
    authorize @event
    if params[:activities].present?
      params[:activities].each do |activity_params|
        activity = Activity.new(
          title: activity_params["title"],
          description: activity_params["description"],
          genres: JSON.parse(activity_params["genres"]),
          age: activity_params["age"]
        )

        if activity.save
          ActivitiesEvent.create(activity: activity, event: @event)
        else
          Rails.logger.info activity.errors.full_messages
        end
      end
    end

    redirect_to @event, notice: 'Event plan was successfully saved.'
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

  private

  def event_params
    params.require(:event).permit(:title, :duration, :date, :num_activities, :age_range)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_event
    authorize @event
  end
end
