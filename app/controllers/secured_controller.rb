# Uses Auth0 to authorize users
class SecuredController < ApplicationController
  include Secured

  before_action :authorize
end
