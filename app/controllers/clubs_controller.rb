class ClubsController < ApplicationController

  before_action :authenticate_user!
  before_action :no_member_access

  def index
    @clubs = policy_scope(Club)
    @wineries = @clubs.map{ |c| c.winery }
    @wineries.uniq!
  end

  def show
    @club = Club.find( params[:id] )
    authorize @club
  end

  def edit
    @club = Club.find( params[:id] )
    authorize @club
  end

  def update
    @club = Club.find(params[:id])
    authorize @club
    @club.assign_attributes(club_params)
    if @club.save
      flash[:notice] = 'Club was updated successfully'
      redirect_to @club
    else
      flash.now[:alert] = 'There was an error saving this club. Please try again later.'
      render :edit
    end
  end

  def new
    @club = Club.new
    authorize @club
    @wineries = policy_scope(Winery)
    @club.winery = @wineries.first
  end

  def create
    @club = Club.new(club_params)
    authorize @club
    if @club.save
      flash[:notice] = 'Club was saved successfully'
      redirect_to @club
    else
      flash.now[:alert] = 'There was an error saving the club. Please try again later.'
      render :new
    end
  end

  def destroy
    @club = Club.find( params[:id] )
    authorize @club
    if @club.destroy
      flash[:notice] = "Club deleted successfully"
      redirect_to clubs_path
    else
      flash.now[:alert] = "There was an error deleting this club. Please try again later."
      redirect_to @club
    end
  end



  private

  def club_params
    params.require(:club).permit(:name, :description, :winery_id)
  end



end
