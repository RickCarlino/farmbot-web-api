# The tokens controller provide a means of authenticating users of the system.
# When a token is created, it is attached to the header of every subsiquent
# request.
class Api::V1::TokensController < ApplicationController
  skip_before_action :run_filters, only: [:create]

  # POST api/v1/tokens
  #
  # * params::email    - Requested user's email address.
  # * params::password - User's password.
  #
  # Returns 200 on success and a json object in the format of {'token': 'xyz'}
  # Returns 401 on failure.
  def create
    @user = User.find_for_authentication(email: params[:email])
    if @user && @user.valid_password?(params[:password])
      @user.ensure_authentication_token!
      render action: 'show', status: :created
    else
      head :unauthorized
    end
  end

  # DELETE api/v1/tokens
  #
  # Token must be provided in the 'FARMBOT-AUTH' HTTP header.
  #
  # Resets the authentication token for a given user.
  def destroy
    if @api_user.reset_authentication_token!
      head :no_content
    else
      head :not_found
    end
  end

private

end