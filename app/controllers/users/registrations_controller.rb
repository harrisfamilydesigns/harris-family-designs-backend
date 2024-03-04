class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    super do |resource|
      if resource.persisted?
        render json: resource, status: :created and return
      else
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity and return
      end
    end
  end
end
