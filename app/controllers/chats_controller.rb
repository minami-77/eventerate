class ChatsController < ApplicationController
  def index
    puts '************'
    puts current_user.inspect
    @chats = policy_scope(Chat)

    puts "********"
    puts @chats
  end
end
