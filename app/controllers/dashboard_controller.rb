class DashboardController < ApplicationController
  def index
    @events = policy_scope(current_user.collaborated_events).order(date: :asc)

    if @events.any?
      first_event = @events.first
      @tasks = policy_scope(first_event.tasks.joins(:tasks_users).where(tasks_users: { user_id: current_user.id }))
    else
      @tasks = []
    end
  end
end
