class Task < ApplicationRecord
  belongs_to :activity
  has_many :tasks_users, dependent: :destroy
  has_many :users, through: :tasks_users

  has_one_attached :photo
end
