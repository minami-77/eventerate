class Message < ApplicationRecord
  belongs_to :user
  # Touch true here updates the chat record it belongs to, so we can order chats by most recent
  belongs_to :chat, touch: true

  after_create_commit :broadcast_message

  def broadcast_message
    broadcast_append_to "chat_#{chat.id}_messages",
      target: "messages_list",
      partial: "chats/message",
      locals: {
        message: self,
        current_user: user
      }
  end
end
