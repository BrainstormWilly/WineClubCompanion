class MembershipsController < ApplicationController

  before_action :authenticate_user!

  def index
    @memberships = Membership.where(user:current_user)
  end

  def create
    @membership = Membership.new(membership_params)
    if @membership.save
      flash[:notice] = 'Membership was saved successfully'
    else
      flash.now[:alert] = 'There was an error saving the membership. Please try again later.'
    end
    redirect_to clubs_path
  end

  def update
    @membership = Membership.find(params[:id])
    @membership.assign_attributes(membership_params)
    if @membership.save
      flash[:notice] = 'Member was updated successfully'
    else
      flash.now[:alert] = 'There was an error saving the user. Please try again later.'
      render :edit
    end
    render :index
  end


  private

  def membership_params
    params.require(:membership).permit(:club_id, :user_id)
  end

end
