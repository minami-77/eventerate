class AddEventReferenceToActivities < ActiveRecord::Migration[7.1]
  def change
    add_reference :activities, :event, foreign_key: true
  end
end
