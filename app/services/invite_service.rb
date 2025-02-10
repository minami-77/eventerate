class InviteService
  def self.already_in_org(org, current_user)
     organization_users = org.organization_users
     puts org.id
     return organization_users.any? { |user| user.id == current_user.id }
  end

  def self.incorrect_email?(invite, current_user)
    return true if invite.email != current_user.email
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
