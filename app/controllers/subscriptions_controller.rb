class SubscriptionsController < ApplicationController

  before_action :authenticate_user!
  before_action :member_only_access


  def index
    # @wineries = current_user.memberships.map{ |m| m.club.winery }.uniq
    # @winery = @wineries.first
  end

  # def update
  # end
  #
  # def new
  # end

  # def create
  # end
  #
  # def destroy
  # end
end
