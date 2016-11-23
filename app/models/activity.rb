class Activity < ApplicationRecord
  belongs_to :winery
  has_many :deliveries

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true
  validates :activity_type, length: { minimum: 1, maximum: 100 }, presence: true
  validates :winery_id, presence: true

  # def slug
  #   if defined? self.activity_sub_type
  #     "#{self.activity_type}_#{self.activity_sub_type}"
  #   else
  #     self.activity_type
  #   end
  # end
end
