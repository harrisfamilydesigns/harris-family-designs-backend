class UsersController < ApplicationController
  before_action :verify_current_user!

  def current
    if current_user.nil?
      render json: { error: "User not found" }, status: :not_found
      return
    end

    render json: UserSerializer.new(current_user).json, status: :ok
  end

  def update_current
    if current_user.update(update_params)
      render json: UserSerializer.new(current_user).json, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def update_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :address,
    )
  end
end
