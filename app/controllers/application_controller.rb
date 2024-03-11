require "google/cloud/storage"
class ApplicationController < ActionController::API
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  # rescue_from ActiveRecord::RecordNotSaved, with: :record_not_saved
  # rescue_from ActiveRecord::RecordNotDestroyed, with: :record_not_destroyed

  def serve_from_gcs
    path = request.path
    path = path[1..-1] if path.starts_with?("/")
    bucket = storage_client.bucket("hfd-fe")
    file = bucket.file(path)
    file ||= bucket.file("index.html")
    if file
      content = file.download
      content.rewind
      send_data content.read, type: file.content_type, disposition: "inline"
    else
      render plain: "File not found", status: :not_found
    end
  end


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

  private

  def storage_client
    credentials = JSON.parse(Rails.application.credentials.dig(:google_cloud, :credentials))
    Google::Cloud::Storage.new(
      project_id: credentials["project_id"],
      credentials: credentials
    )
  end
end
