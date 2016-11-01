class MembershipPolicy < ApplicationPolicy

  attr_reader :user, :membership

  def initialize(user, membership)
    @user = user
    @membership = membership
  end

  def show?
    user.admin? || user == membership.user || (user.manager? && Account.exists?(user: user, winery: membership.club.winery))
  end

  def update?
    show?
  end

  def edit?
    show?
  end

  def new?
    user.admin? || (user.manager? && Account.exists?(user: user, winery: membership.club.winery))
  end

  def create?
    new?
  end

  def destroy?
    new?
  end

  class Scope < Scope

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        return scope.all
      end
      user.role_memberships
    end

  end

end
