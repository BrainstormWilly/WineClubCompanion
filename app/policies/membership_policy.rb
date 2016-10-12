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
      memberships = []
      if @user.member?
        memberships = scope.where(user: @user)
      elsif @user.admin?
        memberships = scope.all
      else
        accounts = Account.where(user: @user)
        accounts.each do |a|
          memberships << scope.where(club: Club.where(winery: a.winery))
        end
        memberships.flatten!
      end
      memberships
    end

  end

end
