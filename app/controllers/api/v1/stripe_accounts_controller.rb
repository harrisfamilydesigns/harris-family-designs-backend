class Api::V1::StripeAccountsController < ApplicationController
  before_action :verify_current_user!

  # GET /stripe_accounts/current
  def current
    stripe_account = current_user.thrifter&.stripe_account

    if (stripe_account.nil?)
      render json: nil, status: :ok
      return
    end

    if (stripe_account.stripe_account_id.nil?)
      render json: nil, status: :ok
      return
    end

    account = Stripe::Account.retrieve(stripe_account.stripe_account_id)

    render json: StripeAccountSerializer.new(account).json, status: :ok
  end

  # This actually creates a stripe account and an account link
  # POST /stripe_accounts/account_link
  def account_link
    stripe_account = current_user.stripe_account || current_user.create_stripe_account
    fetched_account = nil

    if stripe_account.stripe_account_id.nil?
      fetched_account = Stripe::Account.create({
        type: 'express',
        country: 'US',
        email: current_user.email,
        capabilities: {
          card_payments: { requested: true }, # Not sure if this is affects onboarding for providers
          transfers: { requested: true },
        },
      })
    else
      fetched_account = Stripe::Account.retrieve(stripe_account.stripe_account_id)
    end

    stripe_account.stripe_account_id = fetched_account.id
    stripe_account.save

    account_link = Stripe::AccountLink.create({
      account: stripe_account.stripe_account_id,
      refresh_url: stripe_account_link_params[:refresh_url],
      return_url: stripe_account_link_params[:return_url],
      type: 'account_onboarding',
    })

    render json: { url: account_link.url }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stripe_account
      @stripe_account = StripeAccount.find_by(user_id: current_user.id)

      if @stripe_account.nil?
        render json: { error: "Stripe account not found" }, status: :not_found
        return
      end
    end

    def stripe_account_link_params
      params.require(:stripe_account_link).permit(:refresh_url, :return_url)
    end

    def validate_stripe_account_link_params
      # TODO: Make sure it's one of the allowed frontend URLs for hfd/second
    end
end
