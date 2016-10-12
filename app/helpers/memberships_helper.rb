module MembershipsHelper

  def authorized_to_delete?
    current_user.manager? || current_user.admin?
  end

end
