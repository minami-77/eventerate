class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.new(message: params[:message], user: current_user)
    authorize @message
    return if params[:message].blank?

    @message.save
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
