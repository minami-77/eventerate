class TasksController < ApplicationController
  before_action :skip_authorization, only: [:update, :create, :index]
  skip_forgery_protection only: [:complete, :incomplete]

  def index
    event_ids = params[:event_ids].to_s.split(",")
    puts event_ids
    @tasks = policy_scope(Task.joins(:tasks_users).where(event_id: event_ids, tasks_users: { user_id: current_user.id}).distinct)
    render partial: "dashboard/event_tasks_modal", locals: { tasks: @tasks}
  end

  def create
    @event = Event.find(params[:event_id])
    @task = @event.tasks.new(task_params)
    @task.completed = false
    @users = User.joins(:organizations).where(organizations: { id: @event.organization.id })
    if @task.save
      # update assigned user
      assign_user = params[:task][:user_id]
      task_user = TasksUser.new(user_id: assign_user, task_id: @task.id)
      # task_user.save
      if task_user.save
        chat_user = @event.chat.chat_users.find_or_create_by(user_id: assign_user)
      end
      # create collaborator
      existing_collaborators = Collaborator.find_by(event_id: @event.id)
      unless existing_collaborators
        collaborator = Collaborator.new(event_id: @event.id, user_id: assign_user)
        collaborator.save
      end

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

  def update_from_modal
    @task = Task.find(params[:id])
    authorize @task
    if @task.update(tasks_params_modal)
      updated_count = @task.event.unfinished_tasks(current_user)
      updated_percentage = @task.event.completion_percentage
      render json: { success: true, task: @task, unfinished_tasks_count: updated_count, updated_percentage: updated_percentage }
    else
      render json: { success: false, errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @event = Event.find(params[:event_id])
    @task = @event.tasks.find(params[:id])
    @users = User.joins(:organizations).where(organizations: { id: @event.organization.id })

    if @task.update(task_params)

      # update assigned user
      assign_user = params[:task][:user_id]
      task_user = TasksUser.find_by(task_id: @task.id)
      if task_user.present?
        if task_user.update(user_id: assign_user)
          if @event.chat.present?
            chat_user = @event.chat.chat_users.create(user_id: assign_user)
          else
            flash[:error] = "Event chat is not found."
          end
        end
      else
        task_user = TasksUser.new(user_id: assign_user, task_id: @task.id)
        task_user.save
      end

      # update collaborator
      existing_collaborators = Collaborator.where(event_id: @event.id)
      all_task_user_ids = TasksUser.joins(:task).where(tasks: { event_id: @event.id }).pluck(:user_id).uniq

      all_task_user_ids.each do |user_id|
        Collaborator.find_or_create_by(event_id: @event.id, user_id: user_id)
      end
      # existing_collaborators.where.not(user_id: all_task_user_ids).destroy_all

      redirect_to event_path(@event), notice: "Task updated successfully."
    else
      flash[:alert] = @task.errors.full_messages.to_sentence
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    @task = @event.tasks.find(params[:id])
    authorize @task
    if @task.destroy
      redirect_to event_path(@event), notice: "Task deleted successfully."
    else
      flash[:alert] = @task.errors.full_messages.to_sentence
    end
  end

  def complete
    @task = Task.find(params[:id])
    authorize @task
    @task.update(completed: true)
    render json: {id: @task.id, completed: @task.completed}
  end

  def incomplete
    @task = Task.find(params[:id])
    authorize @task
    @task.update(completed: false)
    render json: {id: @task.id, completed: @task.completed}
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

  def tasks_params_modal
    params.require(:task).permit(:completed)
  end

end
