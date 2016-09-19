require 'rails_helper'

RSpec.describe UserController, type: :controller do

  describe "GET #clubs" do
    it "returns http success" do
      get :clubs
      expect(response).to have_http_status(:success)
    end
  end

end
