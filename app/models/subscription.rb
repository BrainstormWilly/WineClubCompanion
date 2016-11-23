class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :delivery

  has_one :activity, through: :delivery
  has_one :winery, through: :activity

  validates :user_id, presence: true
  validates :delivery_id, presence: true

  # def self.by_user_and_winery(u, w)
  #   Subscription.where(user: u).select{ |s| s.delivery.winery == w}
  # end

end
