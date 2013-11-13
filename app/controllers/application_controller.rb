class ApplicationController < ActionController::Base

  skip_before_action :verify_authenticity_token

  before_action :run_filters

  # This is a helper method that allows me to chain the before_action filters in a correct order.
  # This is required because set_user must always be called before check_permissions
  def run_filters
    set_user
    check_permissions
  end

  #TODO: There is too much logic hanging out in this controller. Move check_permissions into a module or something

  # Checks the current users ability to access the current action/controller.
  # First checks the current user's permission list. If the user is not logged in
  # it will check against a list of default authorizations defined within the method
  # Returns :unauthorized if the user is not allowed into that controller action.
  def check_permissions
    if @api_user
      head :unauthorized and return unless @api_user.permit? params[:controller], params[:action]
    else
      target_action = params[:controller] + '#' + params[:action]
      head :unauthorized and return unless User.default_permissions.include?(target_action)
    end
  end

  # Verify that the request has a valid FARMBOT-AUTH header, which is a User authentication_token.
  #
  # Returns 401 on failure
  def set_user
    #OPTIMIZE: Cache this to reduce number of DB hits.
    token = request.headers['FARMBOT-AUTH'] || false
    @api_user = User.find_by(authentication_token: token)
    if @api_user.nil? || !token
      head :unauthorized and return
    end
  end


end
