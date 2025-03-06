class AddActivityToTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :tasks, :activity, foreign_key: true
  end
end
