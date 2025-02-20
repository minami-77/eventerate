class Task < ApplicationRecord
  belongs_to :event
  has_many :tasks_users, dependent: :destroy
  has_many :users, through: :tasks_users

  has_one_attached :photo
  validates :event, presence: true
  attr_accessor :user_id
end
