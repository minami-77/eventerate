class ChangesToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :instructions, :json, default: []
    add_column :activities, :materials, :json, default: []

    remove_column :activities, :genres, :json
  end
end
