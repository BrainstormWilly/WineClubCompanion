class Api::V1::BaseController < ApplicationController

  acts_as_token_authentication_handler_for User


  protected

  def user_unauthorized
    render json: { error: "Not Authorized", status: 403 }, status: 403
  end


end
