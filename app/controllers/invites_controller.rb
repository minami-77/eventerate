class InvitesController < ApplicationController
  def invite_link
    @org = Organization.find(params["id"])
    authorize @org
    @token = Invite.find_by(email: params["email"])
    if @token
      if invite_expired?(@token)
        @token = Invite.create!(email: params["email"])
      end
    else
      @token = Invite.create!(email: params["email"])
    end
    invite_url = "#{root_url}organizations/#{params[:id]}/join?token=#{@token.invite_token}"
    render json: { invite_url: invite_url }
  end

  private

  def invite_expired?(token)
    if token.expires_at < Time.current
      return true
    end
  end
end
