#TODO: There is too much logic hanging out in this controller. Move
# check_permissions into a module or something
class ApplicationController < ActionController::Base

  skip_before_action :verify_authenticity_token

  before_action :run_filters

  # Guarantee order of before_action execution by wraping it in a function.
  def run_filters
    set_user
    authorize
  end

  # Checks the current users ability to access the current action/controller.
  #
  # Will attempt to authorize based on user permissions. If no token is found,
  # will authorize from the default authorization list set in the User model.
  def authorize
    if @api_user
      authorize_user
    else
      authorize_unauthenticated_user
    end
  end

  # Checks against the default permissions list to see if a user is allowed to
  # use a particular Controler / Action. Returns :unauthorized if it is not on
  # the default permissions list.
  def authorize_unauthenticated_user
    target_action = params[:controller] + '#' + params[:action]
    unless User::DEFAULT_PERMISSIONS.include?(target_action)
      head :unauthorized and return
    end
  end

  # Check an authenticated users permission list and return :unauthorized if
  # they do not have permissions to access the current Controller / Action.
  def authorize_user
    unless @api_user.permit? params[:controller], params[:action]
      head :unauthorized and return
    end
  end

  # Verify that the request has a valid FARMBOT-AUTH header, which is a User
  # authentication_token.
  #
  # Returns 401 on failure
  def set_user
    token = request.headers['FARMBOT-AUTH'] || false
    @api_user ||= User.find_by(authentication_token: token)
    if @api_user.nil? || !token
      head :unauthorized and return
    end
  end


end
