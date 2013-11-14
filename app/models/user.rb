# Basic user class for a system user of Farmbot.
# Provides a base for authentication and authorization to Farmbot equipment and
# information.
class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :token_authenticatable
         #TODO: Upgrade from the now deprecated token_authenticable
         # Details here:
         # https://gist.github.com/josevalim/fb706b1e933ef01e4fb6

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String
  field :authentication_token, :type => String

  #TODO: Move this permissions stuff into a service object?

  # This constant serves as a list of all allowed actions for non-authenticated
  # users. The convention is CONTROLLER_NAME, followed by a '#', follwed by the
  # ACTION_NAME
  DEFAULT_PERMISSIONS = [
    'api/v1/users#create',
    'api/v1/tokens#destroy',
    'api/v1/tokens#create'
    ]

  # Holds a list of authorized controller actions in the format of
  # 'api/v1/some_controller#some_action'
  field :permissions, type: Array, default: DEFAULT_PERMISSIONS

  def permit?(controller, action)
    target_action = controller + '#' + action
    if self.permissions.include?(target_action)
      true
    else
      false
    end
  end

  def has_permission?(permission)
    self.permissions.include?(permission)
  end

  def add_permission(permission)
    unless permission.match(/.*#.*/)
      raise 'invalid permission format. '\
            'Permissions must follow the format of '\
            '"name/of/controller#action_name".'
    end
    self.permissions << permission
  end

  def remove_permission(permission)
    unless has_permission?(permission)
      raise "Could not find permission for #{permission}"
    end
    self.permissions.delete(permission)
  end

  def add_permission!(permission)
    add_permission(permission)
    self.save
  end

  def remove_permission!(permission)
    remove_permission(permission)
    self.save
  end

end
