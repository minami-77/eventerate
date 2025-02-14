class Activity < ApplicationRecord
  has_many :activities_events, dependent: :destroy
  has_many :events, through: :activities_events

  validates :title, :age, :genre, presence: true
end
