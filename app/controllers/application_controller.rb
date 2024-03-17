require "google/cloud/storage"
class ApplicationController < ActionController::API
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  # rescue_from ActiveRecord::RecordNotSaved, with: :record_not_saved
  # rescue_from ActiveRecord::RecordNotDestroyed, with: :record_not_destroyed

  before_action :snake_case_params

  def serve_from_gcs
    path = request.path
    path = path[1..-1] if path.starts_with?("/")
    path = path.chomp("/")
    is_asset_path = path.starts_with?("assets/") || path.match?(extension)
    bucket = storage_client.bucket("hfd-fe")
    file = is_asset_path ? bucket.file(path) : bucket.file("index.html")
    if file.nil?
      file = bucket.file("index.html")
    end
    content = file.download
    content.rewind
    send_data content.read, type: file.content_type, disposition: "inline"
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
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

  def verify_current_user!
    return render json: { error: "Unauthorized" }, status: :unauthorized if current_user.nil?
  end

  private

  def storage_client
    credentials = JSON.parse(Rails.application.credentials.dig(:google_cloud, :credentials))
    Google::Cloud::Storage.new(
      project_id: credentials["project_id"],
      credentials: credentials
    )
  end

  def extension
    # 3 or 4 characters long
    /\.(?:[a-z0-9]{3,4})\z/
  end

  def snake_case_params
    params.deep_transform_keys!(&:underscore)
  end
end
