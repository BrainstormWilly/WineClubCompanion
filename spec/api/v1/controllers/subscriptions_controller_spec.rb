require "rails_helper"

RSpec.describe Api::V1::SubscriptionsController, type: :controller do

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
  let!(:delivery11){ create(:delivery, activity: activity11) }
  let!(:delivery12){ create(:delivery, activity: activity12) }
  let!(:delivery21){ create(:delivery, activity: activity21) }
  let!(:delivery31){ create(:delivery, activity: activity31) }
  let!(:account1){ create(:account, user: manager1, winery: winery1) }
  let!(:account2){ create(:account, user: manager1, winery: winery2) }
  let!(:account3){ create(:account, user: manager2, winery: winery3) }
  let!(:subscription11){ create(:subscription, user: member1, delivery: delivery11) }
  let!(:subscription12){ create(:subscription, user: member1, delivery: delivery12) }
  let!(:subscription21){ create(:subscription, user: member1, delivery: delivery21) }
  let!(:subscription31){ create(:subscription, user: member2, delivery: delivery31) }


  context "guest" do
    describe "GET #index" do
      it "redirects to sign in" do
        get :index
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "PUT #update" do
      it "redirects to sign in" do
        put :update, params: {id: subscription11.id, subscription: {activated: true}}
        expect(response).to redirect_to( new_user_session_path )
      end
    end
  end

  context "member" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:member]
      sign_in member1, scope: :user
    end
    describe "GET #index" do
      it "returns http succcess" do
        get :index
        expect(response).to have_http_status(:success)
      end
      it "returns all member subscriptions" do
        get :index
        items = ActiveSupport::JSON.decode(response.body)
        expect(items.count).to eq 3
      end
    end
    describe "PUT #update" do
      it "returns http success on own subscription" do
        put :update, params: {id: subscription11.id, subscription: {activated: true}}
        expect(response).to have_http_status(:success)
      end
      it "returns json on own subscription" do
        put :update, params: {id: subscription11.id, subscription: {activated: true}}
        expect(response.content_type).to eq 'application/json'
      end
      it "updates on own subscription" do
        put :update, params: {id: subscription11.id, subscription: {activated: true}}
        item = ActiveSupport::JSON.decode(response.body)
        expect(item["activated"]).to  be_truthy
      end
      it "does not update on other subscription" do
        put :update, params: {id: subscription31.id, subscription: {activated: true}}
        item = ActiveSupport::JSON.decode(response.body)
        expect(item["activated"]).to  be_falsey
      end
    end
  end

  context "manager" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:manager]
      sign_in manager1, scope: :user
    end
    describe "GET #index" do
      it "returns http succcess" do
        get :index
        expect(response).to have_http_status(:success)
      end
      it "returns all manager subscriptions" do
        get :index
        items = ActiveSupport::JSON.decode(response.body)
        expect(items.count).to eq 3
      end
    end
    describe "PUT #update" do
      it "returns http success on own member subscription" do
        put :update, params: {id: subscription11.id, subscription: {activated: true}}
        expect(response).to have_http_status(:success)
      end
      it "returns json on own member subscription" do
        put :update, params: {id: subscription11.id, subscription: {activated: true}}
        expect(response.content_type).to eq 'application/json'
      end
      it "updates on own subscription" do
        put :update, params: {id: subscription11.id, subscription: {activated: true}}
        item = ActiveSupport::JSON.decode(response.body)
        expect(item["activated"]).to  be_truthy
      end
      it "does not update on other subscription" do
        put :update, params: {id: subscription31.id, subscription: {activated: true}}
        item = ActiveSupport::JSON.decode(response.body)
        expect(item["activated"]).to  be_falsey
      end
    end
  end

  context "admin" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in admin, scope: :user
    end
    describe "GET #index" do
      it "returns http succcess" do
        get :index
        expect(response).to have_http_status(:success)
      end
      it "returns all subscriptions" do
        get :index
        items = ActiveSupport::JSON.decode(response.body)
        expect(items.count).to be > 0
      end
    end
    describe "PUT #update" do
      it "returns http success on member subscription" do
        put :update, params: {id: subscription11.id, subscription: {activated: true}}
        expect(response).to have_http_status(:success)
      end
      it "returns json on member subscription" do
        put :update, params: {id: subscription11.id, subscription: {activated: true}}
        expect(response.content_type).to eq 'application/json'
      end
      it "updates on member subscription" do
        put :update, params: {id: subscription11.id, subscription: {activated: true}}
        item = ActiveSupport::JSON.decode(response.body)
        expect(item["activated"]).to  be_truthy
      end
      it "updates other member subscription" do
        put :update, params: {id: subscription31.id, subscription: {activated: true}}
        item = ActiveSupport::JSON.decode(response.body)
        expect(item["activated"]).to  be_truthy
      end
    end
  end



end
