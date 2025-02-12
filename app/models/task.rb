class Task < ApplicationRecord
  belongs_to :event
  has_many :tasks_users, dependent: :destroy
  has_many :users, through: :tasks_users

  validates :event, presence: true
end
