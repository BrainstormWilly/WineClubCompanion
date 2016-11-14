require "rails_helper"

RSpec.describe Api::V1::MembershipsController, type: :controller do

	context "guest" do
	    describe "POST #search" do
	      it "redirects to sign_in" do
	        post :search, params: {q: "club1"}
	        expect(response).to redirect_to new_user_session_path
	      end
	    end
	 end

	 context "member" do
	    before do
	      @request.env["devise.mapping"] = Devise.mappings[:member]
	      manager = create(:user, role: "manager")
	      other_manager = create(:user, role: "manager")
	      member = create(:user)
	      other_member = create(:user)
	      winery = create(:winery)
	      club = create(:club, name: "club1", winery: winery)
	      other_winery = create(:winery)
	      other_club = create(:club, name: "club2", winery: other_winery)
	      membership = create(:membership, user: member, club: club)
	      other_membership = create(:membership, user: other_member, club: other_club)
	      account = create(:account, user: manager, winery: winery)
	      other_account = create(:account, user: other_manager, winery: other_winery)
	      sign_in member, scope: :user
	    end
	    describe "POST #search" do
	      it "returns http success" do
	        post :search, params: {q: "club1"}
	        expect(response).to have_http_status(:success)
	      end
	      it "returns json" do
	        post :search, params: {q: "club1"}
	        expect(response.content_type).to eq 'application/json'
	      end
	      it "returns results for club1" do
	        post :search, params: {q: "club1"}
	        items = assigns(:memberships)
	        expect(items.count).to eq 1
	      end
	      it "does not return results for club2" do
	        post :search, params: {q: "club2"}
	        items = assigns(:memberships)
	        expect(items.count).to eq 0
	      end
	    end
	 end

	 context "manager" do
	    before do
	      @request.env["devise.mapping"] = Devise.mappings[:manager]
	      manager = create(:user, role: "manager")
	      other_manager = create(:user, role: "manager")
	      member = create(:user)
	      other_member = create(:user)
	      winery = create(:winery)
	      club = create(:club, name: "club1", winery: winery)
	      other_winery = create(:winery)
	      other_club = create(:club, name: "club2", winery: other_winery)
	      membership = create(:membership, user: member, club: club)
	      other_membership = create(:membership, user: other_member, club: other_club)
	      account = create(:account, user: manager, winery: winery)
	      other_account = create(:account, user: other_manager, winery: other_winery)
	      sign_in manager, scope: :user
	    end
	    describe "POST #search" do
	      it "returns http success" do
	        post :search, params: {q: "club1"}
	        expect(response).to have_http_status(:success)
	      end
	      it "returns json" do
	        post :search, params: {q: "club1"}
	        expect(response.content_type).to eq 'application/json'
	      end
	      it "returns results for club1" do
	        post :search, params: {q: "club1"}
	        items = assigns(:memberships)
	        expect(items.count).to eq 1
	      end
	      it "does not return results for club2" do
	        post :search, params: {q: "club2"}
	        items = assigns(:memberships)
	        expect(items.count).to eq 0
	      end
	    end
  	end

  	context "admin" do
	    before do
	      @request.env["devise.mapping"] = Devise.mappings[:admin]
	      admin = create(:user, role: "admin")
	      manager = create(:user, role: "manager")
	      other_manager = create(:user, role: "manager")
	      member = create(:user)
	      other_member = create(:user)
	      winery = create(:winery)
	      club = create(:club, winery: winery)
	      other_winery = create(:winery)
	      other_club = create(:club, winery: other_winery)
	      membership = create(:membership, user: member, club: club)
	      other_membership = create(:membership, user: other_member, club: other_club)
	      account = create(:account, user: manager, winery: winery)
	      other_account = create(:account, user: other_manager, winery: other_winery)
	      sign_in admin, scope: :user
	    end
	    describe "POST #search" do
	      it "returns http success" do
	        post :search, params: {q: "club1"}
	        expect(response).to have_http_status(:success)
	      end
	      it "returns json" do
	        post :search, params: {q: "club1"}
	        expect(response.content_type).to eq 'application/json'
	      end
	      it "returns results for club1" do
	        post :search, params: {q: "club1"}
	        items = assigns(:memberships)
	        expect(items.count).to eq 1
	      end
	      it "returns results for club2" do
	        post :search, params: {q: "club2"}
	        items = assigns(:memberships)
	        expect(items.count).to eq 1
	      end
	    end
  	end

end

