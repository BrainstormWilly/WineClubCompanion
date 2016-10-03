class Users::RegistrationsController < Devise::RegistrationsController


  private

  def after_sign_up_path_for(resource)
    if resource.manager?
      return accounts_path
    end
    clubs_path
  end


end
