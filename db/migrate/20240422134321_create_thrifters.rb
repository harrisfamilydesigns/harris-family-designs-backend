class CreateThrifters < ActiveRecord::Migration[7.1]
  def up
    create_table :thrifters do |t|
      t.string :address
      t.jsonb :preferences
      t.string :experience_level
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    return if Thrifter.any?

    User.find_each do |user|
      if user.thrifter.nil? && user.address
        Thrifter.create!(
          address: user.address,
          preferences: user.preferences,
          experience_level: user.experience_level,
          user: user
        )
      end
    end

    remove_column :users, :address, :string
    remove_column :users, :preferences, :jsonb
    remove_column :users, :experience_level, :string
  end

  def down
    add_column :users, :address, :string
    add_column :users, :preferences, :jsonb
    add_column :users, :experience_level, :string

    Thrifter.find_each do |thrifter|
      thrifter.user.update!(
        address: thrifter.address,
        preferences: thrifter.preferences,
        experience_level: thrifter.experience_level
      )
    end

    drop_table :thrifters
  end
end


