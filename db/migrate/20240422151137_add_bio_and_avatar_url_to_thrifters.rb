class AddBioAndAvatarUrlToThrifters < ActiveRecord::Migration[7.1]
  def change
    add_column :thrifters, :bio, :text
    add_column :thrifters, :avatar_url, :string
  end
end
