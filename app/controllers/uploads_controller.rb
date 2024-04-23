require "google/cloud/storage"

class UploadsController < ApplicationController
  before_action :verify_current_user!

  def create
    bucket = storage_client.bucket('hfd-uploads')
    file = bucket.create_file(upload_params[:file].tempfile, upload_params[:file].original_filename)
    upload = Upload.new(url: file.public_url, user_id: current_user.id)
    if upload.save
      render json: {url: upload.url}, status: :created
    else
      render json: {errors: upload.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def upload_params
    params.permit(:file)
  end

end
