class AddAuth0IdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :auth0_id, :string
    # allow null values for email, encrypted_password
    change_column_null :users, :email, true
    change_column_null :users, :encrypted_password, true
  end
end
