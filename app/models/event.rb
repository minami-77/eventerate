class Event < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :title, presence: true
  validates :date, presence: true
  validates :duration, presence: true
  has_many :activities_events
  has_many :activities, through: :activities_events
  has_many :collaborators, dependent: :destroy
  has_many :users, through: :collaborators
<<<<<<< HEAD
  has_many :tasks, dependent: :destroy
=======
  has_many :activities, dependent: :destroy
  has_many :tasks, through: :activities
>>>>>>> master
end
