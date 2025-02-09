class DashboardController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  def index
    @events = policy_scope(current_user.collaborated_events)
    @tasks = policy_scope(current_user.tasks)
  end
end
