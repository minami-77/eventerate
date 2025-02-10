class InvitesController < ApplicationController
  before_action :skip_authorization, only: [:token_validation, :invite_link]

  def invite_link
    @token = Invite.find_by(email: params["email"])
    @token = TokenService.token_check(@token, params)
    invite_url = "#{root_url}organizations/join?token=#{@token.invite_token}"
    render json: { invite_url: invite_url }
  end

  def verify_token
    puts "****************"
    email = params["email"]
    token = params["token"]
    @existing_token = Invite.find_by(invite_token: token)
    authorize @existing_token
    puts email
    puts token
    if TokenService.invite_expired?(@existing_token)
      flash.now[:alert] = "Error: The invite link has expired. Please contact the administrator of the organization to receive a new link"
      render json: { flash: flash.now[:alert] }, status: :unprocessable_entity
      return
    end

    if TokenService.incorrect_email?(@existing_token, email)
      puts "hi"
      flash.now[:alert] = "Error: The server could not verify your token with this email address"
      render json: { flash: flash.now[:alert] }, status: :unprocessable_entity
      return
    end

    UserService.user_exists?(params)
  end

  def token_validation
    @token = params["token"]
  end
end
