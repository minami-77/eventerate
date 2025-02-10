class TokenService
  def self.incorrect_email?(token, email)
    return true if token.email != email
  end

  def self.token_check(token, params)
    if token
      if invite_expired?(token)
        token = Invite.create!(email: params["email"], organization_id: params[:id])
      end
    else
      token = Invite.create!(email: params["email"], organization_id: params[:id])
    end
    return token
  end

  def self.invite_expired?(token)
    if token.expires_at < Time.current
      return true
    end
  end

end
