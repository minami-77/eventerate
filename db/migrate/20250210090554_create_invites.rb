class CreateInvites < ActiveRecord::Migration[7.1]
  def change
    create_table :invites do |t|
      t.string :email, null: false
      t.string :invite_token, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end
  end
end
