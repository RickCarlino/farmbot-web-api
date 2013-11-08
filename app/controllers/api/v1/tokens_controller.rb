#Session controller provides a token
class Api::V1::TokensController < ApplicationController
  before_filter :set_user, only: [:destroy]

  def create
    @user = User.find_for_authentication(email: params[:email])
    if @user.valid_password?(params[:password])
      @user.ensure_authentication_token!
      render action: 'show', status: :created
    else
      head :unauthorized
    end
  end

  def destroy
    @api_user.reset_authentication_token!
    head :no_content
  end

private

  def set_user
    token = request.headers['FARMBOT-AUTH']
    if 
      @api_user = User.find_by(authentication_token: token)
    else
      head :unauthorized and return
    end
  end

  def user_params
    params.permit(:email, :password)
  end

end