class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :club

  # def self.user_has_memberships(user)
  #   self.where(user:user).count > 0
  # end

  def self.not_in_club(club, user)
    return self.where(club:club, user:user).empty?
  end

end
