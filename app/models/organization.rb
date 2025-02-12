class Organization < ApplicationRecord
  has_many :organization_users
  has_many :users, through: :organization_users
  has_many :events
  has_many :invites, dependent: :destroy

  validates :name, presence: true
end
