class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user, only: :destroy

  def create
    super { |user| @token = current_token(user) }
  end

  def destroy
    super do
      # Your custom logic here, if needed
      render json: { message: "Successfully signed out" }, status: :ok and return
    end
  end

  private

  def current_token(user)
    request.env['warden-jwt_auth.token']
  end

  # Ensure response includes the JWT in the create action
  def respond_with(resource, _opts = {})
    render json: { user: resource, token: @token }, status: :ok
  end
end
