class WineriesController < ApplicationController

  before_action :authenticate_user!
  before_action :verify_access

  def index
    @wineries = policy_scope(Winery)
  end

  def show
    @winery = Winery.find(params[:id])
    authorize @winery
  end

  def edit
    @winery = Winery.find(params[:id])
    authorize @winery
  end

  def update
    @winery = Winery.find(params[:id])
    authorize @winery
    @winery.assign_attributes(winery_params)
    if @winery.save
      flash[:notice] = 'Winery was updated successfully'
      redirect_to @winery
    else
      flash.now[:alert] = 'There was an error saving winery. Please try again later.'
      render :edit
    end

  end

  def new
    @winery = Winery.new
    authorize @winery
  end

  def create
    @winery = Winery.new(winery_params)
    authorize @winery
    if @winery.save
      flash[:notice] = 'Winery was saved successfully'
      redirect_to @winery
    else
      flash.now[:alert] = 'There was an error saving the winery. Please try again later.'
      render :new
    end
  end

  def destroy
    @winery = Winery.find( params[:id] )
    authorize @winery
    if @winery.destroy
      flash[:notice] = "Winery deleted successfully"
      redirect_to wineries_path
    else
      flash.now[:alert] = "There was an error deleting this winery. Please try again later."
      redirect_to @winery
    end
  end


  private

  def verify_access
    if current_user.member?
      user_unauthorized
    end
  end

  def winery_params
    params.require(:winery).permit(:name, :address1, :address2, :city, :state, :zip)
  end


end
