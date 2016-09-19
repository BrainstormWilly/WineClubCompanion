module ClubsHelper

  def is_not_a_member(club)
    return Membership.not_in_club(club, current_user)
  end

end
