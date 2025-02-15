class DashboardController < ApplicationController
  def index
    @events = Event.where(user: current_user)
    @event = Event.new
    @events = policy_scope(current_user.collaborated_events).order(date: :asc).limit(3)

    if @events.any?
      first_event = @events.first
      @tasks = policy_scope(first_event.tasks.joins(:tasks_users).where(tasks_users: { user_id: current_user.id })).limit(3)
    else
      @tasks = []
    end
  end
end
