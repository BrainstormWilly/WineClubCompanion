class Users::SessionsController < Devise::SessionsController

  # def destroy
  #   super
  # end

  private

  def after_sign_in_path_for(resource)
    memberships_path
  end

end
