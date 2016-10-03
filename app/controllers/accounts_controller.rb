class AccountsController < ApplicationController

  def index
    @accounts = Account.where(user: current_user)
  end

end
