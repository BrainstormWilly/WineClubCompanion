require "rails_helper"

RSpec.describe Api::V1::AccountsController, type: :controller do

  context "guest" do
    describe "GET #by_winery" do
      it "redirects to sign_in" do
        get :by_winery
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "GET #by_manager" do
      it "redirects to sign_in" do
        get :by_manager
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context "member" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:member]
      member = create(:user)
      sign_in member, scope: :user
    end
    describe "GET #by_winery" do
      it "returns http 403" do
        get :by_winery
        expect(response).to have_http_status(403)
      end
    end
    describe "GET #by_manager" do
      it "returns http 403" do
        get :by_manager
        expect(response).to have_http_status(403)
      end
    end
  end

  context "manager" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:manager]
      manager = create(:user, role: "manager")
      other_manager = create(:user, role: "manager")
      winery = create(:winery)
      other_winery = create(:winery)
      account = create(:account, user: manager, winery: winery)
      other_account = create(:account, user: other_manager, winery: other_winery)
      sign_in manager, scope: :user
    end
    describe "GET #by_winery" do
      it "returns http success" do
        get :by_winery
        expect(response).to have_http_status(:success)
      end
      it "returns json" do
        get :by_winery
        expect(response.content_type).to eq 'application/json'
      end
      it "returns only the manager's account" do
        get :by_winery
        items = assigns(:accounts)
        expect(items.count).to eq 1
      end
    end
    describe "GET #by_manager" do
      it "returns http success" do
        get :by_manager
        expect(response).to have_http_status(:success)
      end
      it "returns json" do
        get :by_manager
        expect(response.content_type).to eq 'application/json'
      end
      it "returns only the manager's accounts" do
        get :by_manager
        items = assigns(:users)
        expect(items.count).to eq 1
      end
    end
  end

  context "admin" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      admin = create(:user, role: "admin")
      manager = create(:user, role: "manager")
      other_manager = create(:user, role: "manager")
      winery = create(:winery)
      other_winery = create(:winery)
      account = create(:account, user: manager, winery: winery)
      other_account = create(:account, user: other_manager, winery: other_winery)
      sign_in admin, scope: :user
    end
    describe "GET #by_winery" do
      it "returns http success" do
        get :by_winery
        expect(response).to have_http_status(:success)
      end
      it "returns json" do
        get :by_winery
        expect(response.content_type).to eq 'application/json'
      end
      it "returns all accounts" do
        get :by_winery
        items = assigns(:accounts)
        expect(items.count).to eq 2
      end
    end
    describe "GET #by_manager" do
      it "returns http success" do
        get :by_manager
        expect(response).to have_http_status(:success)
      end
      it "returns json" do
        get :by_manager
        expect(response.content_type).to eq 'application/json'
      end
      it "returns all managers' accounts" do
        get :by_manager
        items = assigns(:users)
        expect(items.count).to eq 2
      end
    end
  end

end
