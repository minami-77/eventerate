class ActivitiesEventsController < ApplicationController
  def new
    @event = Event.find(params[:event_id])
    @activity_event = ActivitiesEvent.new
    authorize @activity_event
  end

  def create
    @event = Event.find(params[:event_id])
    @activity_event = ActivitiesEvent.new(activity_params)
    @activity_event.event = @event
    @activity_event.activity = Activity.first # the activity event must make a reference to an activity, otherwise it won't be saved. Any activity is fine.
    authorize @activity_event
    if @activity_event.save
      redirect_to @event, notice: 'Activity was successfully added.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:event_id])
    @activity_event = ActivitiesEvent.find(params[:id])
    authorize @activity_event
  end

  def update
    @event = Event.find(params[:event_id])
    @activity_event = ActivitiesEvent.find(params[:id])
    authorize @activity_event
    if @activity_event.update(activity_params)
      redirect_to @event, notice: 'Activity was successfully updated.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    @activity_event = ActivitiesEvent.find(params[:id])
    authorize @activity_event
    @activity_event.destroy
    redirect_to @event, notice: "Activity was successfully deleted."
  end

  private

  def activity_params
    params.require(:activities_event).permit(:custom_title, :custom_description)
  end
end
