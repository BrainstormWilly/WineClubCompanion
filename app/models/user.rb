class User < ActiveRecord::Base

  has_many :memberships, dependent: :destroy

  # before_save { self.email = email.downcase }
  # after_initialize { self.role ||= :member }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:member, :winery, :admin]

  def fullname
    return "#{self.firstname} #{self.lastname}"
  end

end
