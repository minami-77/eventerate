class ChatService
  def self.create_event_chat(event, user)
    @chat = event.create_chat!
    @chat_user = @chat.chat_users.create!(user: user)
  end
end
