class ChatsController < ApplicationController
  def index
    @chats = policy_scope(Chat).order(updated_at: :desc)
  end

  def show
    # @chats not needed if we redirect_to chats_path in the else part
    # @chats = policy_scope(Chat).order(updated_at: :desc)
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
    authorize @chat
    if turbo_frame_request?
      render partial: "chats/messages", locals: { messages: @messages, chat: @chat, current_user: current_user }
    else
      # render "chats/index", layout: "application"
      redirect_to chats_path
    end
  end

  def get_last_message
    @chat = Chat.find(params["id"])
    @last_message = @chat.messages.last
    @first_name = @last_message.user.first_name
    authorize @chat
    render json: { message: @last_message.message, first_name: @first_name, updated_at: @chat.updated_at }
  end
end
