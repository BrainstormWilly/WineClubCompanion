class ClubPolicy < ApplicationPolicy

  attr_reader :user, :club

  def initialize(user, club)
    @user = user
    @club = club
  end

  def show?
    user.admin? || (user.manager?  && club.winery.account.user == user)
  end

  def edit?
    show?
  end

  def update?
    show?
  end

  def new?
    true
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
      user.role_clubs
    end

  end

end
