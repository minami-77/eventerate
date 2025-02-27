class ActivitiesEvent < ApplicationRecord
  belongs_to :activity
  belongs_to :event

  def display_title
    custom_title.presence || activity.title.capitalize
  end

  def display_description
    custom_description.presence || activity.description
  end
end
