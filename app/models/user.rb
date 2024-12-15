class User < ApplicationRecord
  include AuthLogic

  # # Only need these association if active_apps includes secondhandfix
  has_one :thrifter
  has_one :customer
end
