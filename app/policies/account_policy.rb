class AccountPolicy < ApplicationPolicy

  attr_reader :user, :account

  def initialize(user, account)
    @user = user
    @account = account
  end

  def show?
    user.admin? || (user.manager? && user==account.user)
  end

  # def update?
  #   show?
  # end
  #
  # def edit?
  #   show?
  # end

  def new?
    user.admin?
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
      accounts = []
      if user.admin?
        accounts = scope.all
      elsif user.manager?
        accounts = scope.where(user: user)
      end
      accounts
    end

  end

end
