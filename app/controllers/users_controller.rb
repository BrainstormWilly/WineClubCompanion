class UsersController < ApplicationController

  before_action :authenticate_user!

  def index
    if current_user.member?
      user_unauthorized
    else
      @users = policy_scope(User)
      if current_user.admin?
        @managers = @users.where(role: "manager")
        @members = @users.where(role: "member")
        render :admin_index
      else current_user.manager?
        render :manager_index
      end
    end
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def edit
    @user = User.find(params[:id])
    if current_user == @user
      redirect_to edit_user_registration_path
    else
      authorize @user
      render :edit
    end
  end

  def update
    @user = User.find(params[:id])
    if current_user == @user
      redirect_to edit_user_registration_path
    else
      authorize @user
      @user.assign_attributes(user_params)
      if @user.save
        flash[:notice] = 'User was updated successfully'
        redirect_to @user
      else
        flash.now[:alert] = 'There was an error saving user. Please try again later.'
        render :edit
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user == @user
      redirect_to cancel_user_registration_path
    else
      authorize @user
      if @user.destroy
        flash[:notice] = "User deleted successfully"
        redirect_to users_path
      else
        flash.now[:alert] = "There was an error deleting this user. Please try again later."
        redirect_to @user
      end
    end
  end


  private

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email)
  end

end
