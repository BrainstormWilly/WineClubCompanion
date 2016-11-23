class SubscriptionPolicy < ApplicationPolicy

  attr_reader :user, :subscription

  def initialize(user, subscription)
    @user = user
    @subscription = subscription
  end

  # def show?
  #   user.subscriptions.include?(subscription)
  # end

  def update?
    user.admin? || user.role_subscriptions.include?(subscription)
  end

  # def edit?
  #   show?
  # end

  # def new?
  #   user.admin?
  # end

  # def create?
  #   new?
  # end

  # def destroy?
  #   user.subscriptions.include?(subscription)
  # end

  class Scope < Scope

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      user.admin? ? scope.all : user.role_subscriptions
    end

  end

end
