class EventPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def new?
    create?
  end

  def create?
    user.present?
  end

  def show?
    true
  end

  def preview_event_plan?
    true
  end

  def save_event_plan?
    true
  end

  def save_fake_event_plan?
    true
  end

  def edit?
    user.present?
  end

  def update?
    edit?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def owned_events?
    user.present?
  end

  def collaborated_events?
    user.present?
  end

  def regenerated_activities?
    user.present?
  end

  def fake_preview?
    user.present?
  end

  def fake_regenerated_preview?
    user.present?
  end

  def new_activity_with_ai?
    user.present?
  end
end
