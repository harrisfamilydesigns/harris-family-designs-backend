# Uses Auth0 to authorize users
class SecuredController < ApplicationController
  include Secured

  before_action :authorize

  def current_user
    @_current_user ||= find_or_create_current_user
  end

  private

  def find_or_create_current_user
    Rails.logger.info("Decoded token: #{@decoded_token}")
    user = User.find_by_auth0_id(@decoded_token.token[0]['sub'])

    if user.nil?
      # call out to Auth0 to get the user's email
      # and create a new user in the database
      user = User.create!(auth0_id: @decoded_token.token[0]['sub'])
    end
  end
end
