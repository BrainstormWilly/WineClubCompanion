class Club < ActiveRecord::Base
  belongs_to :winery
  has_many :memberships, dependent: :destroy

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true
end
