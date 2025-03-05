class TasksUsersController < ApplicationController
  def update_tasks_users
    user = User.find(params["user_id"])
    task = Task.find(params["task_id"])

    authorize task

    if task.tasks_users.exists?
      if task.tasks_users.update(user: user)
        render json: { message: "Task user updated successfully" }, status: :ok
      else
        render json: { error: "Failed to update task user" }, status: :unprocessable_entity
      end
    else
      if task.tasks_users.create(user: user)
        render json: { message: "Task user created successfully" }, status: :created
      else
        render json: { error: "Failed to create task user" }, status: :unprocessable_entity
      end
    end

    if task.event.collaborators.find_by(user_id: user.id).nil?
      task.event.collaborators.create!(user: user)
    end
  end
end
