class DashboardController < ApplicationController
  def index
    @start_date = params[:start_date]&.to_date || Date.today
    # Fetch events within the selected month, including owned and collaborated events
    # @events = Event.where(date: @start_date.beginning_of_month..@start_date.end_of_month)
    #           .where(user: current_user)
    #           .or(Event.where(id: current_user.collaborated_events.ids))
    #           .order(date: :asc).limit(3)

    # @events = current_user.collaborated_events.where("date > ?", Date.current).order(date: :asc).limit(3)
    @event = Event.new
    # @events = policy_scope(Event.where(user: current_user).or(Event.where(id: current_user.collaborated_events.ids)).order(date: :asc).limit(3))
    @events = policy_scope(current_user.collaborated_events.where("date > ?", Date.current).order(date: :asc).limit(3))

    if @events.any?
      first_event = @events.first
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
