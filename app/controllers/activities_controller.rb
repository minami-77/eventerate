class ActivitiesController < ApplicationController

  def new_activity_with_ai
    @event = Event.find(params["id"])
    event_title = params["event_title"]
    age = params["age"]
    generated_activity = RegenerateActivityService.regenerate_activity(event_title, age)

    authorize @event

    new_activity = @event.activities.new(
      title: generated_activity["title"],
      description: generated_activity["description"],
      instructions: generated_activity["instructions"].to_json,
      materials: generated_activity["materials"].to_json
    )

    #To pass to frontend
    task_ids = []
    task_titles = []

    if new_activity.save
      generated_activity["tasks"].each do |task|
        new_task = create_task(task, new_activity, @event)
        task_ids << new_task.id
        task_titles << new_task.title
      end
      # redirect_to event_path(@event), notice: 'Activity and tasks created successfully.'
      render json: { activity: generated_activity, activity_id: new_activity.id, taskIds: task_ids, users: get_org_users, taskTitles: task_titles }
    else
      puts new_activity.errors.full_messages
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    @activity = Activity.find(params[:id])
    authorize @activity
    @activity.destroy
    redirect_to @event, notice: "Activity was successfully deleted."
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

  def create_task(task, activity, event)
    new_task = activity.tasks.new(title: task)
    new_task.event = event
    new_task.save
    return new_task
  end
end
