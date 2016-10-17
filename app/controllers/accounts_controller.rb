class AccountsController < ApplicationController

  before_action :authenticate_user!
  before_action :verify_access

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
    @winery = Winery.new(name: "Unknown Winery")
    @manager = User.new(role: "manager", firstname: "Unknown", lastname: "Manager")
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
    else
      flash.now[:alert] = 'There was an error saving the account. Please try again later.'
    end
    redirect_to @account
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

  def verify_access
    if current_user.member?
      user_unauthorized
    end
  end

  def account_params
    params.require(:account).permit(:winery_id, :user_id)
  end

end
