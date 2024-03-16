class Users::PasswordsController < Devise::PasswordsController
  # POST /resource/password
  # Send reset password instructions
  # example curl command:
  #   curl -X POST -H "Content-Type: application/json" -d '{"user": {"email": "max@hfd.com"}}' http://api.hfd.localhost:4444/users/password
  #
  def create
    self.resource = resource_class.send_reset_password_instructions(create_params)
    if successfully_sent?(resource)
      render json: { message: "Reset password instructions sent successfully" }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /resource/password
  # example curl command:
  #   curl -X PUT -H "Content-Type: application/json" -d '{"user": {"reset_password_token": "abcdef", "password": "newpassword", "password_confirmation": "newpassword"}}' http://api.hfd.localhost:4444/users/password
  #
  def update
    reset_password_token = Devise.token_generator.digest(resource_class, :reset_password_token, update_params[:token])
    self.resource = resource_class.find_by(reset_password_token: reset_password_token)

    resource.update(update_params.except(:token))
    if resource.errors.empty?
      render json: { message: "Password reset successfully" }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:user).permit(:email)
  end

  def update_params
    params.require(:user).permit(:token, :password, :password_confirmation)
  end
end
