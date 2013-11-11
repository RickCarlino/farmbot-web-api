class ApplicationController < ActionController::Base

  skip_before_action :verify_authenticity_token

  before_action :set_user

  # Verify that the request has a valid FARMBOT-AUTH header, which is a User authentication_token.
  #
  # Returns 401 on failure
  def set_user
    token = request.headers['FARMBOT-AUTH'] || false
    @api_user = User.find_by(authentication_token: token)
    if @api_user.nil? || !token
      head :unauthorized and return
    end
  end


end
