class Invite < ApplicationRecord
  before_create :generate_invite_token

  def generate_invite_token
    self.invite_token = SecureRandom.hex(10)
    self.expires_at = 6.hours.from_now
  end

  validates :email, uniqueness: true
end
