class WelcomeController < ApplicationController

  def index
    @user = User.new
  end

  def search
    # normally we will run one or more services here to retrieve clubs
    @user = User.new(params.require(:user).permit(:email))
    @clubs = Club.all.first(2)

  end

end
