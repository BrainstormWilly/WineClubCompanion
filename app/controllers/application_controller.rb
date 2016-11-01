class ApplicationController < ActionController::Base

  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_unauthorized


  protected

  # Devise
  def after_sign_in_path_for(resource)
    if resource.member?
      return memberships_path
    end
    accounts_path
  end

  # Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:firstname, :lastname, :email, :role, :password, :password_confirmation) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:firstname, :lastname, :email, :role, :password, :password_confirmation, :current_password) }
    # devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
  end

  def user_unauthorized
    flash[:alert] = "You are not authorized to do this."
    redirect_to(request.referrer || authenticated_root_path)
  end

  def no_member_access
    if current_user.member?
      user_unauthorized
    end
  end


end
