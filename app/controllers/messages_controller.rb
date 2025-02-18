class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @messages = @chat.messages
    @message = @messages.new(message: params[:message])
    @message.user = current_user
    authorize @message
    if @message.save
      if @message.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.append(:messages_list, partial: "chats/message",
              locals: { message: @message })
          end
          format.html { redirect_to booking_path(@booking) }
        end
      else
        render "chats/chats", status: :unprocessable_entity
      end
      # render partial: "chats/messages", locals: { chat: @chat, messages: @messages }
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
