require 'elasticsearch/model'

class User < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  acts_as_token_authenticatable

  has_many :memberships, dependent: :destroy
  has_many :accounts, dependent: :destroy


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  default_scope { order('lastname ASC') }

  before_save { self.email = email.downcase }
  before_save :ensure_authentication_token
  after_initialize { self.role ||= :member }

  validates :firstname, length: { minimum: 1, maximum: 100 }, presence: true
  validates :lastname, length: { minimum: 1, maximum: 100 }, presence: true
  validates :role, presence: true

  enum role: [:member, :manager, :admin]

  def fullname
    "#{firstname} #{lastname}"
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  # managers and members only
  def role_memberships
    if member?
      memberships
    else
      role_clubs.map{ |c| c.memberships }.flatten
    end
  end

  def role_wineries
    if member?
      memberships.map{ |m| m.club.winery }
    else
      accounts.map{ |a| a.winery }
    end
  end

  def role_clubs
    if member?
      memberships.map{ |m| m.club }
    else
      role_wineries.map{ |w| w.clubs }.flatten
    end
  end

  def role_users
    if member?
      [self]
    else
      role_memberships.map{ |m| m.user }.uniq
    end
  end



  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end

User.import force: true
