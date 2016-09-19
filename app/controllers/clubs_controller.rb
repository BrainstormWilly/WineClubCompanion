class ClubsController < ApplicationController

  def index
    @clubs = Club.all.first(2) # acquired from service

  end


end
