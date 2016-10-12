class Account < ApplicationRecord
  belongs_to :user
  belongs_to :winery

  def self.has_account?( user, winery )
    return self.where( user: user, winery: winery ).count > 0
  end

end
