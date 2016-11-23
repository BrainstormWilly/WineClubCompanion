require 'elasticsearch/model'

class User < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  acts_as_token_authenticatable

  has_many :memberships, dependent: :destroy
  has_many :accounts, dependent: :destroy
  has_many :subscriptions, dependent: :destroy


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
    if self.authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def is_subscribed_to_winery?(winery)
    self.subscriptions.each do |s|
      if s.delivery.activity.winery == winery
        return true
      end
    end
    false
  end


  # managers and members only
  def role_memberships
    if self.member?
      self.memberships
    else
      self.role_clubs.map{ |c| c.memberships }.flatten
    end
  end

  def role_wineries
    if self.member?
      self.memberships.map{ |m| m.club.winery }.uniq
    else
      self.accounts.map{ |a| a.winery }
    end
  end

  def role_clubs
    if self.member?
      self.memberships.map{ |m| m.club }
    else
      self.role_wineries.map{ |w| w.clubs }.flatten
    end
  end

  def role_activities
    if self.member?
      self.subscriptions.map{ |s| s.delivery.activity }.uniq
    else
      self.role_wineries.map{ |w| w.activities }.flatten
    end
  end

  def role_subscriptions
    if self.member?
      self.subscriptions
    else
      self.role_memberships.map{ |m| m.user.subscriptions }.flatten.uniq
    end
  end

  def role_users
    if self.member?
      [self]
    else
      self.role_memberships.map{ |m| m.user }.uniq
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
