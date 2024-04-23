class ThriftersController < ApplicationController
  before_action :verify_current_user!
  before_action :set_thrifter, only: %i[ show update destroy ]
  before_action :authorize_admin!, only: %i[ index ]
  before_action :authorize_owner!, only: %i[ show update destroy ]

  # GET /thrifters
  def index
    @thrifters = Thrifter.all

    render json: @thrifters.map{ |thrifter| ThrifterSerializer.new(thrifter).json }, status: :ok
  end

  # GET /thrifters/1
  def show
    render json: ThrifterSerializer.new(@thrifter).json, status: :ok
  end

  # POST /thrifters
  def create
    @thrifter = Thrifter.new(thrifter_params)

    if @thrifter.save
      render json: ThrifterSerializer.new(@thrifter).json, status: :created, location: @thrifter
    else
      render json: {errors: @thrifter.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /thrifters/1
  def update
    if thrifter_params[:status] && @thrifter.status != thrifter_params[:status]
      new_status = thrifter_params.delete(:status)
      begin
        Thrifters::HandleStatusTransition.call(@thrifter, new_status)
      rescue AASM::InvalidTransition => e
        render json: {errors: e.message}, status: :unprocessable_entity and return
      end
    end
    if @thrifter.update(thrifter_params)
      render json: ThrifterSerializer.new(@thrifter).json, status: :ok
    else
      render json: {errors: @thrifter.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # DELETE /thrifters/1
  def destroy
    @thrifter.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_thrifter
      @thrifter = Thrifter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def thrifter_params
      params.require(:thrifter).permit(
        :user_id,
        :address,
        :preferences,
        :experience_level,
        :bio,
        :avatar_url,
        :status
      )
    end

    def authorize_owner!
      return if current_user.id == @thrifter.user_id

      render json: { error: "You are not authorized to perform this action" }, status: :unauthorized
    end

    def authorize_admin!
      return if current_user.admin?

      render json: { error: "You are not authorized to perform this action" }, status: :unauthorized
    end
end
