class ActivitiesController < ApplicationController

  def new_activity_with_ai
    @event = Event.find(params["id"])
    event_title = params["event_title"]
    age = params["age"]
    generated_activity = RegenerateActivityService.regenerate_activity(event_title, age)

    new_activity = @event.activities.new(
      title: params["title"],
      description: params["description"],
      instructions: params["instructions"].to_json,
      materials: params["materials"].to_json
    )

    if new_activity.save
      params["tasks"].each do |task|
        create_task(task, new_activity)
      end
      redirect_to event_path(@event), notice: 'Activity and tasks created successfully.'
      # render json: generated_activity
    end



  end

  private

  def create_task(task, activity)
    new_task = activity.tasks.new(title: task)
    new_task.save
  end
end
