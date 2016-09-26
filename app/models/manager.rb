class Manager < ApplicationRecord
  belongs_to :user
  belongs_to :winery
end
