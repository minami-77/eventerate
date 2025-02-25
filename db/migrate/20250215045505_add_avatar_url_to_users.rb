class AddAvatarUrlToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :avatar_url, :string, default: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"
  end
end
