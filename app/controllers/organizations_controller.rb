class OrganizationsController < ApplicationController
  def show
  end

  def new
    @organization = Organization.new
    authorize @organization
  end

  def create
    @organization = Organization.new(organization_params)
    authorize @organization
    if @organization.save
      new_organization_user = create_organization_user
      if new_organization_user.save
        redirect_to root_path
      else
        render json: { errors: new_organization_user.errors.full_messages }
      end
    else
      render json: { errors: @organization.errors.full_messages }
    end
  end

  private

  def create_organization_user
    new_organization_user = OrganizationUser.new(role: "manager")
    new_organization_user.organization = @organization
    new_organization_user.user = current_user
    return new_organization_user
  end

  def organization_params
    params.require(:organization).permit(:name)
  end
end
