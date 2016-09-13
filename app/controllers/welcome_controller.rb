class WelcomeController < ApplicationController

  def index
    @user = User.new
  end

  def login
  end

  def search
    # normally we will run one or more services here to retrieve clubs
    @member = User.new(params.require(:member).permit(:email), role: "member")
    @clubs = Club.all.sample(2)
  end

end
