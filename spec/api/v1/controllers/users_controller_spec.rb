require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do

	context "guest" do
	    describe "POST #search_members" do
	      it "redirects to sign_in" do
	        post :search_members, params: {q: "willy"}
	        expect(response).to redirect_to new_user_session_path
	      end
	    end
	 end

 	context "member" do
	    before do
	      @request.env["devise.mapping"] = Devise.mappings[:member]
	      member = create(:user, firstname: "Billy", lastname: "Smith")
	      sign_in member, scope: :user
	    end
	    describe "POST #search_members" do
	      it "returns http 403" do
	        post :search_members, params: {q: "billy"}
	        expect(response).to have_http_status(403)
	      end
	    end
	 end

 	context "manager" do
	    before do
	      @request.env["devise.mapping"] = Devise.mappings[:manager]
	      member = create(:user, firstname: "Billy", lastname: "Smith")
	      other_member = create(:user, firstname: "Billy", lastname: "Johnson")
	      manager = create(:user, role: "manager")
	      other_manager = create(:user, role: "manager")
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
	    describe "POST #search_members" do
	      it "returns http success" do
	        post :search_members, params: {q: "billy"}
	        expect(response).to have_http_status(:success)
	      end
	      it "returns json" do
	        post :search_members, params: {q: "billy"}
	        expect(response.content_type).to eq 'application/json'
	      end
	      it "returns results for member" do
	        post :search_members, params: {q: "billy"}
	        items = assigns(:users)
	        expect(items.count).to eq 1
	      end
	      it "does not return results for other member" do
	        post :search_members, params: {q: "billy"}
	        items = assigns(:users)
	        item = items.first
	        expect(item.lastname).to eq "Smith"
	      end
	    end
	 end

	 context "admin" do
	    before do
	      @request.env["devise.mapping"] = Devise.mappings[:admin]
	      admin = create(:user, role: "admin")
	      member = create(:user, firstname: "Billy", lastname: "Smith")
	      other_member = create(:user, firstname: "Billy", lastname: "Johnson")
	      manager = create(:user, role: "manager")
	      other_manager = create(:user, role: "manager")
	      winery = create(:winery)
	      club = create(:club, name: "club1", winery: winery)
	      other_winery = create(:winery)
	      other_club = create(:club, name: "club2", winery: other_winery)
	      membership = create(:membership, user: member, club: club)
	      other_membership = create(:membership, user: other_member, club: other_club)
	      account = create(:account, user: manager, winery: winery)
	      other_account = create(:account, user: other_manager, winery: other_winery)
	      sign_in admin, scope: :user
	    end
	    describe "POST #search_members" do
	      it "returns http success" do
	        post :search_members, params: {q: "billy"}
	        expect(response).to have_http_status(:success)
	      end
	      it "returns json" do
	        post :search_members, params: {q: "billy"}
	        expect(response.content_type).to eq 'application/json'
	      end
	      it "returns results for member" do
	        post :search_members, params: {q: "billy"}
	        items = assigns(:users)
	        expect(items.count).to eq 2
	      end
	    end
	 end



end