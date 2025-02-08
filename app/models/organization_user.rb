class OrganizationUser < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  validates :role, inclusion: { in: ["user", "manager"] }
end
