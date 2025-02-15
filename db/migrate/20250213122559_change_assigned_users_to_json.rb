class ChangeAssignedUsersToJson < ActiveRecord::Migration[7.1]
  def change
    remove_column :activities_events, :assigned_users
    add_column :activities_events, :assigned_users, :json, default: []
  end
end
