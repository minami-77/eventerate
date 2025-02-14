class CreateActivitiesEventsJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :activities_events do |t|
      t.references :activity, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :assigned_users, array: true, default: []  # Array field for assigned users

      t.timestamps
    end
  end
end
