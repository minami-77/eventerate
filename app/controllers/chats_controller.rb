class ChatsController < ApplicationController
  def index
    @chats = policy_scope(Chat).order(updated_at: :desc)
  end

  def show
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
    authorize @chat
    if turbo_frame_request?
      render partial: "chats/messages", locals: { messages: @messages, chat: @chat, current_user: current_user }
    else
      render "chats/index", layout: "application"
    end
  end
end
