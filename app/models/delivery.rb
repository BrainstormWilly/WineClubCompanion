class Delivery < ApplicationRecord
  belongs_to :activity
  has_one :winery, through: :activity

  enum channel: [:email, :text, :phone, :notification]

  after_initialize { self.channel ||= :email }

  validates :activity_id, presence: true
  validates :channel, presence: true
  
end
