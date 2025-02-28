class DashboardController < ApplicationController
  def index
    @event = Event.new
    @date = params["start_date"]
    @events = policy_scope(current_user.collaborated_events.where("date >= ?", (@date || Date.current)).order(date: :asc))
    @upcoming_events = policy_scope((Event.where(user: current_user).where("date >= ?", Date.current)).or(Event.where(id:current_user.collaborated_events).where("date >= ?", Date.current)).order(date: :asc).limit(4))
    # @events = policy_scope(Event.where(user: current_user).or(Event.where(id: current_user.collaborated_events.ids)).order(date: :asc).limit(4))

    if @events.any?
      first_event = @events.first
      # @tasks = policy_scope(first_event.tasks.joins(:tasks_users).where(tasks_users: { user_id: current_user.id })).limit(3)
      @tasks = policy_scope(current_user.tasks)
    else
      @tasks = []
    end
  end

  def owned_events
    authorize @owned_events = current_user.owned_events.order(date: :asc)
  end

  def collaborated_events
    authorize @collaborated_events = current_user.collaborated_events.order(date: :asc)
  end
end
