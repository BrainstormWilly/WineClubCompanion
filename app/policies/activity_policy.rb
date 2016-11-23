class ActivityPolicy < ApplicationPolicy

  attr_reader :user, :activity

  def initialize(user, activity)
    @user = user
    @activity = activity
  end

  class Scope < Scope

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      Activity.all    
    end

  end


end
