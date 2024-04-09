require "google/cloud/storage"
class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotSaved, with: :record_not_saved
  rescue_from ActiveRecord::RecordNotDestroyed, with: :record_not_destroyed
  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters

  before_action :snake_case_params

  def serve_from_gcs
    # Normalize the path
    path = request.path.delete_prefix('/').chomp('/')

    if request.subdomain == 'secondhand'
      bucket = storage_client.bucket('secondhandfix') # reactnative web build
      file = find_file_in_bucket(bucket, path)
      file ||= bucket.file("index.html") # When the path is just a frontend route
    else
      bucket = storage_client.bucket('hfd-fe') # vite build
      is_asset_path = path.starts_with?("assets/") || path.match?(extension)
      file = is_asset_path ? bucket.file(path) : bucket.file("index.html")
      file ||= bucket.file("index.html")
    end

    if file
      content = file.download
      content.rewind
      send_data content.read, type: file.content_type, disposition: "inline"
    else
      record_not_found
    end
  rescue Google::Cloud::NotFoundError => e
    record_not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def record_not_found
    render json: { error: 'Not found' }, status: :not_found
  end

  def record_invalid
    render json: { error: 'Invalid' }, status: :unprocessable_entity
  end

  def record_not_saved
    render json: { error: 'Not saved' }, status: :unprocessable_entity
  end

  def record_not_destroyed
    render json: { error: 'Not destroyed' }, status: :unprocessable_entity
  end

  def unpermitted_parameters(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
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

  def find_file_in_bucket(bucket, path)
    # Check if the requested path directly maps to a file
    # When it's a direct_file, the kind is "storage#object",
    # when it's a directory it's "storage#objects"
    file = bucket.file(path)
    is_direct_file = file.present? && file.kind == "storage#object"
    return file if is_direct_file

    # For directory requests, try serving "index.html" within the directory
    if path.blank? || path.end_with?('/')
      directory_index = "#{path}index.html"
    else
      directory_index = "#{path}/index.html"
    end

    bucket.file(directory_index)
  end
end
