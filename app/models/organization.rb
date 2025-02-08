class Organization < ApplicationRecord
  has_many :organization_users

  validates :name, presence: true
end
