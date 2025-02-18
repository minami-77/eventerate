class ChatsController < ApplicationController
  def index
    @chats = policy_scope(Chat)
  end

  def show
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
    authorize @chat
    if turbo_frame_request?
      puts "***************"
      render partial: "chats/messages", locals: { messages: @messages, chat: @chat }
    else
      render "chats/index", layout: "application"
    end
  end
end
