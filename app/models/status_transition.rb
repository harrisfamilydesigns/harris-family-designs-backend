class StatusTransition < ApplicationRecord
  belongs_to :transitionable, polymorphic: true
end
