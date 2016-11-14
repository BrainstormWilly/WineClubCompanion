class AccountsController < ApplicationController

  before_action :authenticate_user!
  before_action :no_member_access

  def index
    @accounts = policy_scope(Account)
    if current_user.admin?
      @managers = User.where(role: 'manager')
      render :admin_index
    else
      render :manager_index
    end
  end

  def show
    @account = Account.find( params[:id] )
    authorize @account
  end

  def new
    @wineries = Winery.all
    @managers = User.where(role:"manager")
    @account = Account.new
    if current_user.manager?
      @account.user_id = current_user.id
    end
    authorize @account
  end

  def create
    @account = Account.new(account_params)
    authorize @account
    if @account.save
      flash[:notice] = 'Account was saved successfully'
      redirect_to @account
    else
      flash.now[:alert] = 'There was an error saving the account. Please try again later.'
      render :new
    end

  end

  def destroy
    @account = Account.find( params[:id] )
    authorize @account
    if @account.destroy
      flash[:notice] = "Account deleted successfully"
      redirect_to accounts_path
    else
      flash.now[:alert] = "There was an error deleting this account. Please try again later."
      redirect_to @account
    end
  end


  private

  def after_sign_up_path_for(resource)
    if resource.manager?
      return accounts_path
    end
    clubs_path
  end

  def after_sign_in_path_for(resource)
    if resource.manager?
      return accounts_path
    end
    memberships_path
  end

  def verify_access
    if current_user.member?
      user_unauthorized
    end
  end

  def account_params
    params.require(:account).permit(:winery_id, :user_id)
  end

end
