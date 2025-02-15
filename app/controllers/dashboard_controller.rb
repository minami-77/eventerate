class DashboardController < ApplicationController
  def index
    @collaborated_events = policy_scope(current_user.collaborated_events).order(date: :asc)
    if @collaborated_events.any?
      first_event = @collaborated_events.first
      @tasks = policy_scope(first_event.tasks.joins(:tasks_users).where(tasks_users: { user_id: current_user.id })).limit(3)
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
