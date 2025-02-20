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

  def get_last_message
    @chat = Chat.find(params["id"])
    @last_message = @chat.messages.last
    @first_name = @last_message.user.first_name
    authorize @chat
    render json: { message: @last_message.message, first_name: @first_name }
  end
end
