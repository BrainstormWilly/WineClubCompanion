require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "members" do
    before do
      @member = create(:user)
    end
    describe "GET #member_sign_in" do
      it "returns http success" do
        get :member_sign_in
        expect(response).to have_http_status(:success)
      end
    end
    describe "POST #member_sign_in" do
      it "returns http success" do
        post :member_sign_in, params: {user: {email: @member.email, password: @member.password}}
        expect(response).to have_http_status(:success)
      end
    end
  end

  context "managers" do
    describe "GET #manager_sign_in" do
      it "returns http success" do
        get :manager_sign_in
        expect(response).to have_http_status(:success)
      end
    end
  end

end
