require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "members" do

    describe "GET #member_sign_up" do
      it "returns http success" do
        get :member_sign_up
        expect(response).to have_http_status(:success)
      end
    end

  end

end
