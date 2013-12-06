# Management of User resources.
# TODO: Filtering of permissions to prevent users from editing other users
class Api::V1::UsersController < ApplicationController
  before_action :set_api_v1_user, only: [:show, :update, :destroy]
  skip_before_action :run_filters, only: [:create]
  # GET /api/v1/users
  # GET /api/v1/users.json
  def index
    @users = User.all
  end

  # GET /api/v1/users/1
  # GET /api/v1/users/1.json
  def show
  end

  ##
  # == POST /api/v1/users
  # == POST /api/v1/users.json
  #
  # Authenticate the user and save
  # [Required POST VARS]
  #   email::String
  #   password::String
  # === Success
  # [200] OK
  # === Failure
  # [420] User must be logged in
  # [422] Invalid params
  def create
    @user = User.new(user_params)
    if @user.save
      render action: 'show', status: :created
    else
      render json: @user.errors.to_json, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/users/1
  # PATCH/PUT /api/v1/users/1.json
  def update
    if @user.update_attributes(user_params)
      head :no_content, status: 200
    end
  end

  # DELETE /api/v1/users/1
  # DELETE /api/v1/users/1.json
  def destroy
    @user.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_user
      unless @user = User.find(params[:id])
        render json: {error: 'document not found'}, status: 404
      end
    end

    # Never trust parameters from the scary internet, only allow the white list
    # through.
    def user_params
      params.permit(:email, :password)
    end
end
