class User < ActiveRecord::Base

  default_scope { order('lastname ASC') }

  has_many :memberships, dependent: :destroy
  has_many :accounts, dependent: :destroy
  has_many :wineries, through: :accounts
  has_many :clubs, through: :wineries

  before_save { self.email = email.downcase }
  after_initialize { self.role ||= :member }

  validates :firstname, length: { minimum: 1, maximum: 100 }, presence: true
  validates :lastname, length: { minimum: 1, maximum: 100 }, presence: true
  validates :role, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:member, :manager, :admin]

  def fullname
    return "#{self.firstname} #{self.lastname}"
  end

end
