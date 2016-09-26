class Users::RegistrationsController < Devise::RegistrationsController

  def new
    super
  end

  private

  def after_sign_up_path_for(resource)
    # if resource.winery?
    #   return winery_path(resource)
    # end
    clubs_path
  end

end
