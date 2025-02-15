class ChangeGenresToJson < ActiveRecord::Migration[7.1]
  def change
    remove_column :activities, :genre
    add_column :activities, :genres, :json, default: []
  end
end
