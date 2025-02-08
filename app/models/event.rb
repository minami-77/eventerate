class Event < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  has_many :collaborators
  has_many :activities
end
