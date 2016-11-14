class Api::V1::ClubsController < Api::V1::BaseController

  before_action :no_member_access

  def by_winery
    @wineries = policy_scope(Winery)
    render json: @wineries, each_serializer: WinerySerializer
  end

  def by_club
    @clubs = policy_scope(Club)
    render json: @clubs, each_serializer: ClubSerializer
  end

  def search_by_winery

    if params[:q].empty?
      return by_winery
    else
      q_wineries = Winery.search(params[:q]).records
    end

    if current_user.admin?
      u_wineries = Winery.all
    else
      u_wineries = current_user.role_wineries
    end
    
    @wineries = q_wineries & u_wineries
    
    render json: @wineries, each_serializer: WinerySerializer
  end

  def search_by_club

    if params[:q].empty?
      return by_club
    else
      q_clubs = Club.search(params[:q]).records
    end

    if current_user.admin?
      u_clubs = Club.all
    else
      u_clubs = current_user.role_clubs
    end

    @clubs = q_clubs & u_clubs
    
    render json: @clubs, each_serializer: ClubSerializer
  end

end
