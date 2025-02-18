class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @messages = @chat.messages
    @message = @messages.new(message: params[:message])
    @message.user = current_user
    authorize @message
    if @message.save
      render partial: "chats/messages", locals: { chat: @chat, messages: @messages }
    end
  end

  # def show
  #   @chats = Chat.find(params[:id])
  #   @messages = @chats.messages
  #   puts "*******"
  #   puts @chats
  #   if turbo_frame_request?
  #     puts "***************"
  #     render partial: "chats/messages", locals: { messages: @messages }
  #   else
  #     render "chats/index", layout: "application"
  #   end
  # end
end
