class EventsController < ApplicationController
  before_action :skip_authorization, only: [:show]
  def show
    @event =Event.find(params[:id])
  end
end
