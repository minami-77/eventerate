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
    @users = User.joins(:organizations).where(organizations: { id: @event.organization.id })
    @activities = Activity.where(event_id: @event)
    @task = @event.tasks.new
    @suggestions = @task.content
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
end
