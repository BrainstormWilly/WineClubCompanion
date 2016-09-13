class MembersController < ApplicationController

  def create
    # normally we will run one or more services here to retrieve clubs
    @member = User.new(params.require(:member).permit(:email), role: "member")
    @clubs = Club.all.sample(2)
  end

  private

  def member_params
    params.require(:member).permit(:firstname, :lastname, :email, :password_digest)
  end

end
