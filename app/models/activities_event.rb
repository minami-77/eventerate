class ActivitiesEvent < ApplicationRecord
  belongs_to :activity
  belongs_to :event
end
