class CreateOrganizationUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_users do |t|
      t.references :organization, null: false
      t.references :user, null: false
      t.string :role, default: "user"

      t.timestamps
    end
  end
end
