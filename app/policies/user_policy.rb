class UserPolicy < ApplicationPolicy

  attr_reader :user

  def initialize(user, membership)
    @user = user
  end

  def memberships
    user.admin? || user.manager?
  end

  def show?
    user.admin? || user == current_user
  end

  def update?
    show?
  end

  def edit?
    show?
  end

  def new?
    user.admin? || user.manager?
  end

  def create?
    new?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      users = []
      if user.admin?
        users = scope.all
      else
        accounts = Account.where(user: user)
        wineries = accounts.map{ |a| a.winery }
        clubs = Club.where(winery: wineries)
        memberships = Membership.where( club: clubs )
        users = memberships.map{ |m| m.user }.uniq{ |u| u.id }
      end
      users
    end

  end

end
