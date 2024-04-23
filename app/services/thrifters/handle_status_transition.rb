module Thrifters
  class HandleStatusTransition < ApplicationService
    def initialize(thrifter, new_status)
      @thrifter = thrifter
      @new_status = new_status
    end

    def call
      return unless @status_transition.present? && @thrifter.status != @new_status

      case [@thrifter.status, @new_status]
      when ["new", "signing_up"]
        @thrifter.mark_signing_up!
      when ["signing_up", "active"]
        @thrifter.mark_active!
      else
        raise AASM::InvalidTransition, "Cannot transition from #{@thrifter.status} to #{@new_status}"
      end
    end
  end
end
