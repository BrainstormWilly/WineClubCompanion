require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #search" do

    before do
      @user = build(:user)
    end

    it "returns http success" do
      get :search, params: {user: {email: @user.email}}
      expect(response).to have_http_status(:success)
    end
  end

end
