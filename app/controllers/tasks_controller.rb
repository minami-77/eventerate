class TasksController < ApplicationController
  before_action :skip_authorization, only: [:update, :create]

  def create
    @event = Event.find(params[:event_id])
    @task = @event.tasks.new(task_params)
    @task.completed = false
    @users = User.all
    if @task.save
      # update assigned user
      assign_user = params[:task][:user_id]
      task_user = TasksUser.new(user_id: assign_user, task_id: @task.id)
      task_user.save

      redirect_to event_path(@event), notice: "Task created successfully."
    else
      flash[:alert] = @task.errors.full_messages.to_sentence
    end
  end

  def create_ai_task
    @event = Event.find(params[:id])
    tasks_params["title"].each do |title|
      task = Task.new
      task.title = title
      task.completed = false
      task.event = @event
      authorize task
      task.save
    end
    redirect_to event_path(@event), notice: "Task created successfully."
   end





  def update
    @event = Event.find(params[:event_id])
    @task = @event.tasks.find(params[:id])
    @users = User.all
    if @task.update(task_params)
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

  def task_params
    params.require(:task).permit(:title, :user_id, :completed, :comment).tap do |whitelisted|
    whitelisted[:completed] = whitelisted[:completed] == "Completed"
    end
  end

  def tasks_params
    params.require(:task).permit(title:[])
  end

end
