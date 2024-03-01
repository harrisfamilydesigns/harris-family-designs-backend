class ApplicationController < ActionController::API
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  # rescue_from ActiveRecord::RecordNotSaved, with: :record_not_saved
  # rescue_from ActiveRecord::RecordNotDestroyed, with: :record_not_destroyed

  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end

  def record_invalid
    render json: { error: 'Record invalid' }, status: :unprocessable_entity
  end

  def record_not_saved
    render json: { error: 'Record not saved' }, status: :unprocessable_entity
  end

  def record_not_destroyed
    render json: { error: 'Record not destroyed' }, status: :unprocessable_entity
  end
end
