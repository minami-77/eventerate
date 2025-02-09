class DashboardController < ApplicationController
  def index
    @events = policy_scope(current_user.collaborated_events)
    @tasks = policy_scope(current_user.tasks)
  end
end
