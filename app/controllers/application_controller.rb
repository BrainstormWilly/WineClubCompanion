class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_unauthorized



  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:firstname, :lastname, :email, :role, :password, :password_confirmation) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:email, :password) }
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
