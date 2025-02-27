class AddCustomFieldsToActivitiesEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :activities_events, :custom_title, :string
    add_column :activities_events, :custom_description, :string
  end
end
