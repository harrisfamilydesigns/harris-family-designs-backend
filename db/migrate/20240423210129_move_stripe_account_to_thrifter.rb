class MoveStripeAccountToThrifter < ActiveRecord::Migration[7.1]
  def up
    # Temporarily allow nulls
    add_reference :stripe_accounts, :thrifter, null: true, foreign_key: true

    StripeAccount.find_each do |stripe_account|
      thrifter = Thrifter.find_or_create_by!(user_id: stripe_account.user_id)
      stripe_account.update!(thrifter_id: thrifter.id)
    end

    # Change the column to not allow nulls
    change_column_null :stripe_accounts, :thrifter_id, false

    remove_reference :stripe_accounts, :user, index: true
  end

  def down
    add_reference :stripe_accounts, :user, null: true, foreign_key: true

    StripeAccount.find_each do |stripe_account|
      stripe_account.update!(user_id: stripe_account.thrifter.user_id)
    end

    change_column_null :stripe_accounts, :user_id, false

    remove_reference :stripe_accounts, :thrifter, index: true
  end
end
