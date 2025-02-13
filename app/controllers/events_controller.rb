class EventsController < ApplicationController
  before_action :skip_authorization, only: [:show]

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    authorize @event
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    @event.organization = Organization.first
    authorize @event
    if @event.save
      redirect_to root_path
    else
      Rails.logger.info @event.errors.full_messages
      render :new
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :duration, :date)
  end

end
