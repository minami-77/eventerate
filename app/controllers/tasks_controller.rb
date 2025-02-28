class TasksController < ApplicationController
  before_action :skip_authorization, only: [:update, :create]

  def create
    @event = Event.find(params[:event_id])
    @task = @event.tasks.new(tasks_params)
    @users = @event.organization.users
    if @task.save
      # update assigned user
      assign_user = params[:task][:user_id]
      task_user = TasksUser.new(user_id: assign_user, task_id: @task.id)
      Collaborator.find_or_create_by(event: @event, user_id: assign_user)
      if task_user.save
        chat_user = @event.chat.chat_users.create(user_id: assign_user)
      end
      redirect_to event_path(@event), notice: "Task created successfully."
    else
      flash[:alert] = @task.errors.full_messages.to_sentence
    end
  end

  def update
    @event = Event.find(params[:event_id])
    @task = @event.tasks.find(params[:id])
    @users = @event.organization.users
    if @task.update(tasks_params)
      # update assigned user
      assign_user = params[:task][:user_id]
      task_user = TasksUser.find_by(task_id: @task.id)
      Collaborator.find_or_create_by(event: @event, user_id: assign_user)
      if task_user.update(user_id: assign_user)
        chat_user = @event.chat.chat_users.create(user_id: assign_user)
      end
      redirect_to event_path(@event), notice: "Task updated successfully."
    else
      flash[:alert] = @task.errors.full_messages.to_sentence
    end
  end

  private

  def tasks_params
      params.require(:task).permit(:title, :user_id, :completed, :comment).tap do |whitelisted|
    whitelisted[:completed] = whitelisted[:completed] == "Completed"
    end
  end

end
