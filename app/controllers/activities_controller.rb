class ActivitiesController < ApplicationController
  def destroy
    @event = Event.find(params[:event_id])
    @activity = Activity.find(params[:id])
    authorize @activity
    @activity.destroy
    redirect_to @event, notice: "Activity was successfully deleted."
  end
end
