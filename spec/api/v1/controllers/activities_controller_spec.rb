require "rails_helper"

RSpec.describe Api::V1::ActivitiesController, type: :controller do

  let!(:member1){ create(:user) }
  let!(:member2){ create(:user) }
  let!(:manager1){ create(:user, role: "manager") }
  let!(:manager2){ create(:user, role: "manager") }
  let!(:admin){ create(:user, role: "admin") }
  let!(:winery1){ create(:winery) }
  let!(:winery2){ create(:winery) }
  let!(:winery3){ create(:winery) }
  let!(:club11){ create(:club, winery: winery1) }
  let!(:club12){ create(:club, winery: winery1) }
  let!(:club21){ create(:club, winery: winery2) }
  let!(:club22){ create(:club, winery: winery2) }
  let!(:club31){ create(:club, winery: winery3) }
  let!(:membership11){ create(:membership, user: member1, club: club11) }
  let!(:membership12){ create(:membership, user: member1, club: club12) }
  let!(:membership21){ create(:membership, user: member1, club: club21) }
  let!(:membership22){ create(:membership, user: member1, club: club22) }
  let!(:membership31){ create(:membership, user: member2, club: club31) }
  let!(:activity11){ create(:activity, winery: winery1) }
  let!(:activity12){ create(:activity, winery: winery1) }
  let!(:activity21){ create(:activity, winery: winery2) }
  let!(:activity31){ create(:activity, winery: winery3) }
  let!(:account1){ create(:account, user: manager1, winery: winery1) }
  let!(:account2){ create(:account, user: manager1, winery: winery2) }
  let!(:account3){ create(:account, user: manager2, winery: winery3) }

  context "guest" do
    describe "GET #by_winery" do
      it "redirects to sign in" do
        get :by_winery, params: {id: 0}
        expect(response).to redirect_to( new_user_session_path )
      end
    end
  end

  context "member" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:member]
      sign_in member1, scope: :user
    end
    describe "GET #by_winery on my activity" do
      it "returns http success" do
        get :by_winery, params: {id: 0}
        expect(response).to have_http_status(:success)
      end
      it "returns json" do
        get :by_winery, params: {id: 0}
        expect(response.content_type).to eq 'application/json'
      end
      it "returns 2 activities when id=0" do
        get :by_winery, params: {id: 0}
        items = ActiveSupport::JSON.decode(response.body)
        expect(items.count).to eq 2
      end
      it "returns activities when my winery" do
        get :by_winery, params: {id: winery2.id}
        items = ActiveSupport::JSON.decode(response.body)
        expect(items.count).to eq 1
      end
      it "returns 0 activities when not my winery" do
        get :by_winery, params: {id: winery3.id}
        items = ActiveSupport::JSON.decode(response.body)
        expect(items.count).to eq 0
      end
    end
  end

  context "manager" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:member]
      sign_in manager1, scope: :user
    end
    describe "GET #by_winery" do
      it "returns http success" do
        get :by_winery, params: {id: 0}
        expect(response).to have_http_status(:success)
      end
      it "returns json" do
        get :by_winery, params: {id: 0}
        expect(response.content_type).to eq 'application/json'
      end
      it "returns 2 activities when id=0" do
        get :by_winery, params: {id: 0}
        items = ActiveSupport::JSON.decode(response.body)
        expect(items.count).to eq 2
      end
      it "returns activities when my winery" do
        get :by_winery, params: {id: winery2.id}
        items = ActiveSupport::JSON.decode(response.body)
        expect(items.count).to eq 1
      end
      it "returns 0 activities when not my winery" do
        get :by_winery, params: {id: winery3.id}
        items = ActiveSupport::JSON.decode(response.body)
        expect(items.count).to eq 0
      end
    end
  end

  context "admin" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:member]
      sign_in admin, scope: :user
    end
    describe "GET #by_winery" do
      it "returns http success" do
        get :by_winery, params: {id: 0}
        expect(response).to have_http_status(:success)
      end
      it "returns json" do
        get :by_winery, params: {id: 0}
        expect(response.content_type).to eq 'application/json'
      end
      it "returns activities of manager1 winery" do
        get :by_winery, params: {id: winery2.id}
        items = ActiveSupport::JSON.decode(response.body)
        expect(items.count).to eq 1
      end
      it "returns activities of manager2 winery" do
        get :by_winery, params: {id: winery3.id}
        items = ActiveSupport::JSON.decode(response.body)
        expect(items.count).to eq 1
      end
    end
  end


end
