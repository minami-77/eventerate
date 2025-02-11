class OrganizationPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def new?
    user.present?
  end

  def create?
    user.present?
  end

  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def invite?
    user.present?
  end

  def invite_link?
    manager_check
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      # scope.joins(:organization_users).where(organization_users: { user_id: current_user.id })
      user.organizations
    end
  end

  private

  def manager_check
    puts "***********"
    record.users.include?(user) && user.organization_users.where(organization_id: record.id, role: "manager").exists?
  end

end
