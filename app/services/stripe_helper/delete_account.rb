# This used during testing to delete test accounts
module StripeHelper
  class DeleteAccount
    def self.call(stripe_account_id)
      return if Rails.env.production?

      stripe_account = StripeAccount.find_by(stripe_account_id: stripe_account_id)
      if stripe_account.nil?
        return
      end

      Stripe::Account.delete(stripe_account_id)
      stripe_account.destroy
    end
  end
end
