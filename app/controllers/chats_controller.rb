class ChatsController < ApplicationController
  def index
    @chats = policy_scope(Chat)
  end

  def show
    @chats = policy_scope(Chat)
    @messages = @chats.first.messages
  end
end
