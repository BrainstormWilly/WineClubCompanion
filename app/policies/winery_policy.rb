class WineryPolicy < ApplicationPolicy

  attr_reader :user, :winery

  def initialize(user, winery)
    @user = user
    @winery = winery
  end

  def show?
    user.admin? || (user.manager?  && user.wineries.include?(winery))
  end

  def edit?
    show?
  end

  def update?
    show?
  end

  def new?
    user.admin?
  end

  def create?
    new?
  end

  def destroy?
    show?
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
      user.role_wineries
    end

  end

end
