class ClubsController < ApplicationController

  def index

    # run service to find available clubs
    @clubs = Club.first(2)

    # then find memberships
    memberships = Membership.where(user: current_user)
    memberships.each do |m|
      if !@clubs.include?(m.club)
        @clubs << m.club
      end
    end


  end


end
