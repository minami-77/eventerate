class TasksController < ApplicationController
  before_action :skip_authorization, only: [:update]

  def update
    @event = Event.find(params[:event_id])
    @task = @event.tasks.find(params[:id])
    @users = User.all
    if @task.update(tasks_params)
      # update assigned user
      assign_user = params[:task][:user_id]
      task_user = TasksUser.find_by(task_id: @task.id)
      task_user.update(user_id: assign_user)

      redirect_to event_path(@event), notice: "Task updated successfully."
    else
      flash[:alert] = @task.errors.full_messages.to_sentence
    end
  end

  private

  def tasks_params
    params.require(:task).permit(:user_id, :completed, :comment)
  end
end
