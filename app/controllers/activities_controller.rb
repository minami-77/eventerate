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

    #To pass to frontend
    task_ids = []

    if new_activity.save
      params["tasks"].each do |task|
        new_task = create_task(task, new_activity)
        task_ids << new_task.id
      end
      redirect_to event_path(@event), notice: 'Activity and tasks created successfully.'
      # render json: { activity: generated_activity, activity_id: new_activity.id, taskIds: task_ids, users: get_org_users }
    end

  end

  private

  def get_org_users
    @users = current_user.organizations.first.users
    users = @users.map do |user|
      {
        id: user.id,
        name: user.first_name,
        photo_url: user.photo.attached? ? user.photo.url : "https://static-00.iconduck.com/assets.00/profile-default-icon-2048x2045-u3j7s5nj.png"
      }
    end
  end

  def create_task(task, activity)
    new_task = activity.tasks.new(title: task)
    new_task.save
    new_task
  end
end
