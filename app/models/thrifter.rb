class Thrifter < ApplicationRecord
  belongs_to :user
  has_many :status_transitions, as: :transitionable

  include AASM
  aasm :status do
    state :new, initial: true
    state :signing_up
    state :active

    event :mark_signing_up do
      transitions from: :new, to: :signing_up
    end

    event :mark_active do
      transitions from: :signing_up, to: :active
    end

    after_all_transitions :create_status_transition
  end

  private

  def create_status_transition
    StatusTransition.create!(
      transitionable: self,
      from: aasm.from_state,
      to: aasm.to_state,
      created_at: Time.current
    )
  end

end
