class AddStatusToThrifters < ActiveRecord::Migration[7.1]
  def change
    add_column :thrifters, :status, :string, default: "new"
  end
end
