class Users::SessionsController < Devise::SessionsController

  

  private

  def after_sign_in_path_for(resource)
    if resource.manager?
      return accounts_path
    end
    memberships_path
  end

end
