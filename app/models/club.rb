class Club < ActiveRecord::Base
  belongs_to :winery
  has_many :memberships, dependent: :destroy
end
