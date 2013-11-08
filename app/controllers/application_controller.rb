class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null

  skip_before_action :verify_authenticity_token #TODO: Turn off CSRF protection for API?

  before_action :set_user

  def set_user
    token = request.headers['FARMBOT-AUTH'] || false
    @api_user = User.find_by(authentication_token: token)
    if @api_user.nil? || !token
      head :unauthorized and return
    end
  end


end
