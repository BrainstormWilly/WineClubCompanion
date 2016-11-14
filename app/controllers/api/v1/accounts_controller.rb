class Api::V1::AccountsController < Api::V1::BaseController

  before_action :no_member_access

  def by_winery
    @accounts = policy_scope(Account)
    render json: @accounts, each_serializer: AccountSerializer
  end

  def by_manager
    @users = []
    if current_user.admin?
      @users = User.where(role: "manager")
    elsif current_user.manager?
      @users = [current_user]
    end
    render json: @users, each_serializer: UserSerializer
  end

  def search_by_winery
    if params[:q].empty?
      return by_winery
    else
      q_accounts = Account.search(params[:q]).records
    end

    if current_user.admin?
      u_accounts = Account.all
    else
      u_accounts = current_user.accounts
    end

    @accounts = q_accounts & u_accounts

    render json: @accounts, each_serializer: AccountSerializer
  end

  def search_by_manager

    if params[:q].empty?
      return by_manager
    else
      q_users = User.search(params[:q]).records
    end

    if current_user.admin?
      u_users = User.where(role: "manager")
    else
      u_users = [current_user]
    end

    @users = q_users & u_users

    render json: @users, each_serializer: UserSerializer
  end

end
