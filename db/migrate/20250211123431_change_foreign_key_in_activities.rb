class ChangeForeignKeyInActivities < ActiveRecord::Migration[7.1]
  def change
    # Remove the old foreign key
    remove_reference :activities, :event, foreign_key: true
  end
end
