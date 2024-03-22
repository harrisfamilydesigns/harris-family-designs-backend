class AddExperienceLevelToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :experience_level, :string
  end
end
