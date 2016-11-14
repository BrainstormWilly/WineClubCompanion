require "rails_helper"

RSpec.describe Api::V1::WineriesController, type: :controller do

	context "guest" do
	    describe "POST #search" do
	      it "redirects to sign_in" do
	        post :search, params: {q: "willy"}
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
	    describe "POST #search" do
	      it "returns http 403" do
	        post :search, params: {q: "billy"}
	        expect(response).to have_http_status(403)
	      end
	    end
	 end

 	context "manager" do
	    before do
	      @request.env["devise.mapping"] = Devise.mappings[:manager]
	      member = create(:user)
	      other_member = create(:user)
	      manager = create(:user, role: "manager")
	      other_manager = create(:user, role: "manager")
	      winery = create(:winery, name: "My Winery")
	      club = create(:club, name: "club1", winery: winery)
	      other_winery = create(:winery, name: "Other Winery")
	      other_club = create(:club, name: "club2", winery: other_winery)
	      membership = create(:membership, user: member, club: club)
	      other_membership = create(:membership, user: other_member, club: other_club)
	      account = create(:account, user: manager, winery: winery)
	      other_account = create(:account, user: other_manager, winery: other_winery)
	      sign_in manager, scope: :user
	    end
	    describe "POST #search" do
	      it "returns http success" do
	        post :search, params: {q: "Winery"}
	        expect(response).to have_http_status(:success)
	      end
	      it "returns json" do
	        post :search, params: {q: "Winery"}
	        expect(response.content_type).to eq 'application/json'
	      end
	      it "returns results for winery" do
	        post :search, params: {q: "Winery"}
	        items = assigns(:wineries)
	        expect(items.count).to eq 1
	      end
	      it "does not return results for other winery" do
	        post :search, params: {q: "Winery"}
	        items = assigns(:wineries)
	        item = items.first
	        expect(item.name).to eq "My Winery"
	      end
	    end
	 end

	 context "admin" do
	    before do
	      @request.env["devise.mapping"] = Devise.mappings[:admin]
	      admin = create(:user, role: "admin")
        member = create(:user, firstname: "Billy", lastname: "Smith")
	      other_member = create(:user)
	      manager = create(:user, role: "manager")
	      other_manager = create(:user, role: "manager")
	      winery = create(:winery, name: "My Winery")
	      club = create(:club, name: "club1", winery: winery)
	      other_winery = create(:winery, name: "Other Winery")
	      other_club = create(:club, name: "club2", winery: other_winery)
	      membership = create(:membership, user: member, club: club)
	      other_membership = create(:membership, user: other_member, club: other_club)
	      account = create(:account, user: manager, winery: winery)
	      other_account = create(:account, user: other_manager, winery: other_winery)
	      sign_in admin, scope: :user
	    end
	    describe "POST #search" do
	      it "returns http success" do
	        post :search, params: {q: "Winery"}
	        expect(response).to have_http_status(:success)
	      end
	      it "returns json" do
	        post :search, params: {q: "Winery"}
	        expect(response.content_type).to eq 'application/json'
	      end
	      it "returns results for winery" do
	        post :search, params: {q: "Winery"}
	        items = assigns(:wineries)
	        expect(items.count).to eq 2
	      end
	    end
	 end



end
