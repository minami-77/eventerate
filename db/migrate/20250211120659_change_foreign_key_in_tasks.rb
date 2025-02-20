class ChangeForeignKeyInTasks < ActiveRecord::Migration[7.1]
  def change
    # Remove the old foreign key
    remove_reference :tasks, :activity, foreign_key: true

    # Add the new foreign key
    add_reference :tasks, :event, foreign_key: true
  end
end
