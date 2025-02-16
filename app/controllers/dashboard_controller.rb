class DashboardController < ApplicationController
  def index
    @start_date = params[:start_date]&.to_date || Date.today
    # Fetch events within the selected month, including owned and collaborated events
    @events = Event.where(date: @start_date.beginning_of_month..@start_date.end_of_month)
              .where(user: current_user)
              .or(Event.where(id: current_user.collaborated_events.ids))
              .order(date: :asc).limit(3)

    @event = Event.new
    # @events = Event.where(user: current_user).or(Event.where(id: current_user.collaborated_events.ids)).order(date: :asc).limit(3)

    if @events.any?
      first_event = @events.first
      @tasks = policy_scope(first_event.tasks.joins(:tasks_users).where(tasks_users: { user_id: current_user.id })).limit(3)
    else
      @tasks = []
    end
  end
end
