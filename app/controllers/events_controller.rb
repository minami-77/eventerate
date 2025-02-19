class EventsController < ApplicationController
  before_action :skip_authorization, only: [:show]
  before_action :set_event, only: [:show, :edit, :update]

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
    if @event.save
      @event.generate_activities
      redirect_to @event, notice: 'Event was successfully created.'
    else
      Rails.logger.info @event.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def add_activity
    @event = Event.find(params[:id])
    @activity_event = ActivityEvent.new(activity_params)
    @activity_event.event = @event
    @activity_event.activity = Activity.first # the activity event must make a reference to an activity, otherwise it won't be saved. Any activity is fine.
    authorize @activity_event
    if @activity_event.save
      redirect_to @event, notice: 'Activity was successfully added.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :duration, :date, :num_activities, :age_range)
  end

  def activity_params
    params.require(:activity_event).permit(:custom_title, :custom_description)
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
