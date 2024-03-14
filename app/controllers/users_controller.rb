class UsersController < ApplicationController
  def current
    if current_user.nil?
      render json: { error: "User not found" }, status: :not_found
      return
    end

    render json: UserSerializer.new(current_user).json, status: :ok
  end
end
