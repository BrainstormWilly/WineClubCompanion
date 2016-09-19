class Users::RegistrationsController < Devise::RegistrationsController

  def new
    super
  end

  private

  def after_sign_up_path_for(resource)
    clubs_path
  end

end
