class Api::V1::WineriesController < Api::V1::BaseController

  # before_action :no_member_access

  def index
    if current_user.admin?
      w = Winery.all
    else
      w = current_user.role_wineries
    end
    render json: w.uniq, each_serializer: WinerySerializer
  end

  def search

    if current_user.admin?
      u = Winery.all
    else
      u = current_user.role_wineries
    end

    if !params[:q].empty?
      q = Winery.search(params[:q]).records
      @wineries = u & q
    else
      @wineries = u
    end

    render json: @wineries, each_serializer: WinerySerializer

  end

end
