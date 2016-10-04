class WineriesController < ApplicationController

  def index
    @wineries = Winery.all
  end

  def show
    @winery = Winery.find(params[:id])
  end

end
