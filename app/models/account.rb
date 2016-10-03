class Account < ApplicationRecord
  belongs_to :user
  belongs_to :winery
end
