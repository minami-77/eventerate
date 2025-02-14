class AddDetailsToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :genre, :string, array: true, default: []
    add_column :activities, :description, :text
    add_column :activities, :duration, :integer
  end
end
