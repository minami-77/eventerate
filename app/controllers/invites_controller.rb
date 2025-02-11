class InvitesController < ApplicationController
  before_action :skip_authorization, only: [:token_validation, :invite_link, :invite_result]

  def invite_link
    @token = Invite.find_by(email: params["email"])
    @token = InviteService.token_check(@token, params)
    invite_url = "#{root_url}organizations/join?token=#{@token.invite_token}"
    render json: { invite_url: invite_url }
  end

  def join
    @invite = Invite.find_by(invite_token: params["token"])
    authorize @invite
    @organization = @invite.organization

    # Displays warning message if the link has expired. Set up like this to nil if there are no issues, for the purposes of rendering in the html
    @warning

    if InviteService.already_in_org(@organization, current_user)
      @warning = "You have already belong to this organization"
      return
    end

    if InviteService.invite_expired?(@invite)
      @warning = "The invite link has expired. Please contact the administrator of the organization to receive a new link"
    end

    if InviteService.incorrect_email?(@invite, current_user)
      @warning = "The invite link and your user details do not match. Please contact the adminstrator of the organization to resolve this issue"
    end
  end

  def invite_result
    result = params["invite_result"]
    @organization = Organization.find(params["org_id"])
    join_organization(result, @organization)
  end

  private

  def join_organization(result, organization)
    if result == "Accept invite"
      new_organization_user = OrganizationUser.new(role: "user")
      new_organization_user.organization = organization
      new_organization_user.user = current_user
      new_organization_user.save
    end
  end

  # def verify_token
  #   email = params["email"]
  #   @existing_token = Invite.find_by(invite_token: params["token"])
  #   authorize @existing_token

  #   if TokenService.invite_expired?(@existing_token)
  #     flash.now[:alert] = "Error: The invite link has expired. Please contact the administrator of the organization to receive a new link"
  #     render json: { flash: flash.now[:alert] }, status: :unprocessable_entity
  #     return
  #   end

  #   # if TokenService.incorrect_email?(@existing_token, email)
  #   #   puts "hi"
  #   #   flash.now[:alert] = "Error: The server could not verify your token with this email address"
  #   #   render json: { flash: flash.now[:alert] }, status: :unprocessable_entity
  #   #   return
  #   # end

  # end

  # def token_validation
  #   @token = params["token"]
  # end
end
