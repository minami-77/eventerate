class OrganizationsController < ApplicationController
    def show
    @organization = Organization.find(params[:id])
    authorize @organization
    @role = current_user.organization_users.find_by(organization_id: params[:id]).role
    @managers = User.joins(:organization_users).where(organization_users: { role: "manager", organization_id: @organization.id })
    # Use the below instead if scalability due to large amounts of users is needed. Copy for the below users too if that's the case
    # @managers = @organization.organization_users.where(role: "manager").map(&:user)
    @users = User.joins(:organization_users).where(organization_users: { role: "user", organization_id: @organization.id })
  end

  def invite
    @organization = Organization.find(params[:id])
    authorize @organization
  end

  def index
    @organizations = policy_scope(Organization)
    puts @organizations
  end

  def new
    @organization = Organization.new
    authorize @organization
  end

  def create
    @organization = Organization.new(organization_params)
    authorize @organization
    if @organization.save
      new_organization_user = create_organization_manager
      if new_organization_user.save
        redirect_to root_path
      else
        render json: { errors: new_organization_user.errors.full_messages }
      end
    else
      render json: { errors: @organization.errors.full_messages }
    end
  end

  def join
    return unless TokenService.verify_token(params)
  end

  private

  def create_organization_manager
    new_organization_user = OrganizationUser.new(role: "manager")
    new_organization_user.organization = @organization
    new_organization_user.user = current_user
    return new_organization_user
  end

  def organization_params
    params.require(:organization).permit(:name)
  end

end
