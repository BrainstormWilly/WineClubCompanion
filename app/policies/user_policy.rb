class UserPolicy < ApplicationPolicy

  attr_reader :user, :this_user

  def initialize(user, this_user)
    @user = user
    @this_user = this_user
  end

  def memberships
    user.admin? || user.manager?
  end

  def show?
    user == this_user || user.admin? || (user.manager? && user.role_users.include?(this_user))
  end

  def edit?
    user.admin? || (user.manager? && user.role_users.include?(this_user))
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  class Scope < Scope

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        user.role_users
      end
    end

  end

end
