class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    super do |resource|
      if resource.persisted?
        render json: UserSerializer.new(resource).json, status: :created and return
      else
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity and return
      end
    end
  end

  def update
    # if unpermitted parameters are sent, return 422 Unprocessable Entity
    return render json: { errors: ['Something went wrong'] }, status: :unprocessable_entity if unpermitted_params?

    super do |resource|
      if resource.errors.empty?
        render json: UserSerializer.new(resource).json, status: :ok and return
      else
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity and return
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  # Do not allow to change admin attribute
  def account_update_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      :current_password
    )
  end

  def unpermitted_params?
    params.require(:user).keys.map(&:to_sym).any? { |param| !account_update_params.keys.map(&:to_sym).include?(param) }
  end
end
