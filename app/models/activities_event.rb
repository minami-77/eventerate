class ActivitiesEvent < ApplicationRecord
  belongs_to :activity
  belongs_to :event

  serialize :assigned_users, Array
end
