class Message < ApplicationRecord
  belongs_to :user
  # Touch true here updates the chat record it belongs to, so we can order chats by most recent
  belongs_to :chat, touch: true
end
