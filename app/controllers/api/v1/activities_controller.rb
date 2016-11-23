class Api::V1::ActivitiesController < Api::V1::BaseController

  def by_winery
    if current_user.admin?
      wineries = Winery.all
    else
      wineries = current_user.role_wineries
    end

    if params[:id]=="0"
      winery = wineries.first
    else
      winery = Winery.find(params[:id])
    end

    if wineries.include?(winery)
      activities = Activity.where(winery: winery)
    else
      activities = []
    end

    render json: activities, each_serializer: ActivitySerializer
  end

end
