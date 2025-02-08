class Event < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :title, presence: true
  validates :date, presence: true
  validates :duration, presence: true
end
