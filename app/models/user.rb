class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
         :confirmable, :trackable, :recoverable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_one :stripe_account
  has_one :thrifter
  has_one :customer
end
