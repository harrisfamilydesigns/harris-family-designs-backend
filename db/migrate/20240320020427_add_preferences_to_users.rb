class AddPreferencesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :preferences, :jsonb, default: {}
  end
end
