require "rails_helper"

RSpec.describe Api::V1::ClubsController, type: :controller do

  context "guest" do
    describe "GET #by_winery" do
      it "redirects to sign_in" do
        get :by_winery
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "GET #by_club" do
      it "redirects to sign_in" do
        get :by_club
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
    describe "GET #by_club" do
      it "returns http 403" do
        get :by_club
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
      club = create(:club, winery: winery)
      other_winery = create(:winery)
      other_club = create(:club, winery: other_winery)
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
      it "returns only the manager's accounts' wineries" do
        get :by_winery
        items = assigns(:wineries)
        expect(items.count).to eq 1
      end
    end
    describe "GET #by_club" do
      it "returns http success" do
        get :by_club
        expect(response).to have_http_status(:success)
      end
      it "returns json" do
        get :by_club
        expect(response.content_type).to eq 'application/json'
      end
      it "returns only the manager's accounts' clubs" do
        get :by_club
        items = assigns(:clubs)
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
      club = create(:club, winery: winery)
      other_winery = create(:winery)
      other_club = create(:club, winery: other_winery)
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
      it "returns all wineries" do
        get :by_winery
        items = assigns(:wineries)
        expect(items.count).to eq 2
      end
    end
    describe "GET #by_club" do
      it "returns http success" do
        get :by_club
        expect(response).to have_http_status(:success)
      end
      it "returns json" do
        get :by_club
        expect(response.content_type).to eq 'application/json'
      end
      it "returns all clubs" do
        get :by_club
        items = assigns(:clubs)
        expect(items.count).to eq 2
      end
    end
    describe "POST #search_by_winery" do
      it "returns http success" do
        post :search_by_winery
        expect(response).to have_http_status(:success)
      end
      it "returns json" do
        post :search_by_winery
        expect(response.content_type).to eq 'application/json'
      end
      it "returns searched wineries" do
        search_winery = Winery.create(name: "xxx")
        post :search_by_winery, params: {q: "xxx"}
        items = assigns(:wineries)
        expect(items.first).to eq search_winery
      end
    end
    describe "POST #search_by_club" do
      it "returns http success" do
        post :search_by_club
        expect(response).to have_http_status(:success)
      end
      it "returns json" do
        post :search_by_club
        expect(response.content_type).to eq 'application/json'
      end
      it "returns searched wineries" do
        search_club = Club.create(name: "xxx")
        post :search_by_club, params: {q: "xxx"}
        items = assigns(:clubs)
        expect(items.first).to eq search_club
      end
    end
  end

end
