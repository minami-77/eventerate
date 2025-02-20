class User < ApplicationRecord
  has_many :organization_users, dependent: :destroy
  has_many :organizations, through: :organization_users
  has_many :collaborators, dependent: :destroy
  #Owned events
  has_many :owned_events, class_name: 'Event', foreign_key: 'user_id'
  #Collaborated events
  has_many :collaborated_events, through: :collaborators, source: :event
  has_many :tasks_users, dependent: :destroy

  has_many :tasks, through: :tasks_users

  has_many :messages
  has_many :chat_users
  has_many :chats, through: :chat_users
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo, dependent: :purge_later
  # validates :username, presence: true
  # validates :first_name, presence: true
  # validates :last_name, presence: true

  def manager?
    self.role == "manager"
  end
end
