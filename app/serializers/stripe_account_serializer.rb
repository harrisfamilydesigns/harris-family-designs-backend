# This isn't used to serialize our StripeAccount model per se, but rather to serialize a Stripe account object.
class StripeAccountSerializer < BaseSerializer
  def initialize(object)
    @object = object
  end

  def attributes
    {
      id: @object.id,
      object: @object.object, # "account"
      capabilities: {
        card_payments: @object.capabilities.card_payments, # "active"
        transfers: @object.capabilities.transfers, # "active"
      },
      charges_enabled: @object.charges_enabled, # true
      country: @object.country, # "US"
      created: @object.created, # 1600000000
      default_currency: @object.default_currency, # "usd"
      details_submitted: @object.details_submitted, # true
      email: @object.email,
      payouts_enabled: @object.payouts_enabled, # true
      # external_accounts: @object.external_accounts,
      # metadata: @object.metadata,
      # requirements: @object.requirements,
      tos_acceptance: @object.tos_acceptance,
      type: @object.type,
    }
  end
end
