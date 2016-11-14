class Api::V1::UsersController < Api::V1::BaseController

  before_action :no_member_access

  def search_members

    if current_user.admin?
      u_users = User.where(role: "member")
    else
      u_users = current_user.role_users
    end

    if !params[:q].empty?
      q_users = User.search(params[:q]).records
      @users = u_users & q_users
    else
      @users = u_users
    end

    render json: @users, each_serializer: UserSerializer

  end

  def search_managers

    if current_user.admin?
      u_users = User.where(role: "manager")
    else
      u_users = [current_user]
    end

    if !params[:q].empty?
      q_users = User.search(params[:q]).records
      @users = u_users & q_users
    else
      @users = u_users
    end

    render json: @users, each_serializer: UserSerializer

  end

end
