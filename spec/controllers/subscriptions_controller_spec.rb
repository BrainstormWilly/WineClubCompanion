require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  let!(:member){ create(:user) }
  let!(:manager){ create(:user, role: "manager") }
  let!(:admin){ create(:user, role: "admin") }
  let!(:winery){ create(:winery) }
  let!(:account){ create(:account, winery: winery, user: manager) }
  let!(:activity){ create(:activity, winery: winery) }
  let!(:delivery){ create(:delivery, activity: activity) }
  let(:subscription){ create(:subscription, delivery: delivery, user: member) }

  context "guest" do
    describe "GET #index" do
      it "redirects to sign in" do
        get :index
        expect(response).to redirect_to( new_user_session_path )
      end
    end
  end

  context "member" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:member]
      sign_in member, scope: :user
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      it "renders #index view" do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  context "manager" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:manager]
      sign_in manager, scope: :user
    end
    describe "GET #index" do
      it "redirects to root" do
        get :index
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
  end

  context "admin" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in admin, scope: :user
    end
    describe "GET #index" do
      it "redirects to root" do
        get :index
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
  end

end
