class Event < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  has_many :collaborators, dependent: :destroy
  has_many :users, through: :collaborators
  has_many :activities, dependent: :destroy
end
