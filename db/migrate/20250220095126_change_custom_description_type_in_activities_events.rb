class ChangeCustomDescriptionTypeInActivitiesEvents < ActiveRecord::Migration[7.1]
  def change
    change_column :activities_events, :custom_description, :text
  end
end
