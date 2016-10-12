class MembershipsController < ApplicationController

  before_action :authenticate_user!

  def index
    @memberships = policy_scope(Membership)
  end

  def show
    @membership = Membership.find( params[:id] )
    authorize @membership
  end

  def edit
    @membership = Membership.find( params[:id] )
    authorize @membership
  end

  def new
    authorize current_user, :memberships
    @membership = Membership.new
    @members = User.where(role: "member")
    if current_user.admin?
      @clubs = Club.all
    else
      wineries = Account.where(user: current_user).map{ |a| a.winery }
      @clubs = Club.where(winery: wineries)
    end
    @member = User.new(firstname: "New", lastname: "User")
    @club = Club.new(name: "New Club")
  end

  def create
    @membership = Membership.new(create_membership_params)
    authorize @membership
    if @membership.save
      flash[:notice] = 'Membership was saved successfully'
    else
      flash.now[:alert] = 'There was an error saving the membership. Please try again later.'
    end
    redirect_to @membership
  end

  def update
    @membership = Membership.find(params[:id])
    authorize @membership
    @membership.assign_attributes(update_membership_params)
    if @membership.save
      flash[:notice] = 'Membership was updated successfully'
    else
      flash.now[:alert] = 'There was an error saving membership. Please try again later.'
      render :edit
    end
    redirect_to @membership
  end

  def destroy
    @membership = Membership.find(params[:id])
    authorize @membership
    if @membership.destroy
      flash[:notice] = "Membership deleted successfully"
      redirect_to memberships_path
    else
      flash.now[:alert] = "There was an error deleting this membership. Please try again later."
      redirect_to @membership
    end
  end

  private

  def update_membership_params
    params.require(:membership).permit(:registered)
  end

  def create_membership_params
    params.require(:membership).permit(:club_id, :user_id, :registered)
  end

end
