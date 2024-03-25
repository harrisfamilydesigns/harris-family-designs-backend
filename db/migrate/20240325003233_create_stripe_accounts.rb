class CreateStripeAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :stripe_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stripe_account_id

      t.timestamps
    end
  end
end
