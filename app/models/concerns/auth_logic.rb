module AuthLogic
  extend ActiveSupport::Concern

  included do
    if ENV['USE_AUTH0'] == 'true'
      validates :auth0_id, presence: true, uniqueness: true
      validates :email, uniqueness: true, allow_blank: true
    else
      devise :database_authenticatable, :registerable, :validatable,
             :confirmable, :trackable, :recoverable,
             :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

      validates :email, presence: true, uniqueness: true
    end
  end
end
