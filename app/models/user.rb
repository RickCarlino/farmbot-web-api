# Basic user class for a system user of Farmbot.
# Provides a base for authentication and authorization to Farmbot equipment and information.
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

  field :permissions, type: Array, default: []
  # attr_protected :permissions

  def permit?(controller, action)
    permission = controller + '#' + action
    true
  end
end
