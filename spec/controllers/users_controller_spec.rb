require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  # let(:member){ create(:user) }
  # let(:non_member){ create(:user) }
  # let(:manager){ create(:user, role: "manager") }
  # let(:non_manager){ create(:user, role: "manager") }
  # let(:admin){ create(:user, role: "admin") }
  # let(:winery){ create(:winery) }
  # let(:club){ create(:club, winery: winery) }
  # let(:membership){ create(:membership, club: club, user: member) }
  # let(:account){ create(:account, user: manager, winery: winery) }

  context "Guest CRUD" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:manager]
      @member = create(:user)
    end
    describe "GET #index" do
      it "returns http redirect to sign_in" do
        get :index
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "GET #show" do
      it "returns http redirect to sign_in" do
        get :show, params: {id: @member.id}
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "GET #edit" do
      it "returns http redirect to sign_in" do
        get :edit, params: {id: @member.id}
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "PUT #update" do
      it "returns http redirect to sign_in" do
        new_firstname = "Newfirstname"
        put :update, params: {id: @member.id, user: { firstname: new_firstname} }
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "DELETE #destroy" do
      it "returns http redirect to sign_in" do
        delete :destroy, params: {id: @member.id}
        expect(response).to redirect_to( new_user_session_path )
      end
    end
  end

  context "Member CRUD" do
    before do
      @member = create(:user)
      @non_member = create(:user)
      @manager = create(:user, role: "manager")
      @non_manager = create(:user, role: "manager")
      @admin = create(:user, role: "admin")
      @winery = create(:winery)
      @club = create(:club, winery: @winery)
      @membership = create(:membership, club: @club, user: @member)
      @account = create(:account, user: @manager, winery: @winery)
      @request.env["devise.mapping"] = Devise.mappings[:member]
      sign_in @member, scope: :user
    end
    describe "GET #index" do
      it "redirects to root" do
        get :index
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "GET #show" do
      it "returns http success" do
        get :show, params: {id: @member.id}
        expect(response).to have_http_status(:success)
      end
      it "renders the #show view on self" do
        get :show, params: {id: @member.id}
        expect(response).to render_template :show
      end
      it "redirects to root on other member" do
        get :show, params: {id: @non_member.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
      it "redirects to root on manager" do
        get :show, params: {id: @manager.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
      it "redirects to root on manager" do
        get :show, params: {id: @admin.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "GET #edit" do
      it "redirects to edit_user_registration_path on self" do
        get :edit, params: {id: @member.id}
        expect(response).to redirect_to( edit_user_registration_path )
      end
      it "redirects to root on other member" do
        get :edit, params: {id: @non_member.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
      it "redirects to root on manager" do
        get :edit, params: {id: @manager.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
      it "redirects to root on manager" do
        get :edit, params: {id: @admin.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "PUT #update" do
      it "redirects to edit_user_registration_path on self" do
        new_name = "MyNewFirstName"
        put :update, params: {id: @member.id, user: {firstname: new_name}}
        expect(response).to redirect_to( edit_user_registration_path )
      end
      it "redirects to root on other member" do
        new_name = "MyNewFirstName"
        put :update, params: {id: @non_member.id, user: {firstname: new_name}}
        expect(response).to redirect_to( authenticated_root_path )
      end
      it "redirects to root on manager" do
        new_name = "MyNewFirstName"
        put :update, params: {id: @manager.id, user: {firstname: new_name}}
        expect(response).to redirect_to( authenticated_root_path )
      end
      it "redirects to root on admin" do
        new_name = "MyNewFirstName"
        put :update, params: {id: @admin.id, user: {firstname: new_name}}
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "DELETE #destroy" do
      it "redirects to cancel_user_registration on self" do
        delete :destroy, params: {id: @member.id}
        expect(response).to redirect_to( cancel_user_registration_path )
      end
      it "does not delete other member" do
        delete :destroy, params: {id: @non_member.id}
        cnt = User.where(id: @non_member.id).count
        expect(cnt).to eq 1
      end
      it "redirects to root on other member" do
        delete :destroy, params: {id: @non_member.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
      it "does not delete manager" do
        delete :destroy, params: {id: @manager.id}
        cnt = User.where(id: @manager.id).count
        expect(cnt).to eq 1
      end
      it "redirects to root on manager" do
        delete :destroy, params: {id: @manager.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
      it "does not delete admin" do
        delete :destroy, params: {id: @admin.id}
        cnt = User.where(id: @admin.id).count
        expect(cnt).to eq 1
      end
      it "redirects to root on admin" do
        delete :destroy, params: {id: @admin.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
  end

  context "Manager CRUD" do
    before do
      @member = create(:user)
      @non_member = create(:user)
      @manager = create(:user, role: "manager")
      @non_manager = create(:user, role: "manager")
      @admin = create(:user, role: "admin")
      @winery = create(:winery)
      @club = create(:club, winery: @winery)
      @membership = create(:membership, club: @club, user: @member)
      @account = create(:account, user: @manager, winery: @winery)
      @request.env["devise.mapping"] = Devise.mappings[:manager]
      sign_in @manager, scope: :user
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      it "renders index" do
        get :index
        expect(response).to render_template(:manager_index)
      end
    end
    describe "GET #show" do
      it "returns http success on self" do
        get :show, params: {id: @manager.id}
        expect(response).to have_http_status(:success)
      end
      it "renders the #show view on self" do
        get :show, params: {id: @manager.id}
        expect(response).to render_template :show
      end
      it "returns http success on own member" do
        get :show, params: {id: @member.id}
        expect(response).to have_http_status(:success)
      end
      it "renders the #show view on own member" do
        get :show, params: {id: @member.id}
        expect(response).to render_template :show
      end
      it "redirects to root on other member" do
        get :show, params: {id: @non_member.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
      it "redirects to root on other manager" do
        get :show, params: {id: @non_manager.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "GET #edit" do
      it "redirects to edit_user_registration_path on self" do
        get :edit, params: {id: @manager.id}
        expect(response).to redirect_to( edit_user_registration_path )
      end
      it "returns http success on own member" do
        get :edit, params: {id: @member.id}
        expect(response).to have_http_status(:success)
      end
      it "renders edit own member" do
        get :edit, params: {id: @member.id}
        expect(response).to render_template(:edit)
      end
      it "redirects to root on other member" do
        get :edit, params: {id: @non_member.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
      it "redirects to root on admin" do
        get :edit, params: {id: @admin.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "put #update" do
      it "redirects to edit_user_registration_path on self" do
        new_name = "MyNewFirstName"
        put :update, params: {id: @manager.id, user: {firstname: new_name}}
        expect(response).to redirect_to( edit_user_registration_path )
      end
      it "redirects to #show on own member" do
        new_name = "MyNewFirstName"
        put :update, params: {id: @member.id, user: {firstname: new_name}}
        expect(response).to redirect_to(@member)
      end
      it "updates own member" do
        new_name = "MyNewFirstName"
        put :update, params: {id: @member.id, user: {firstname: new_name}}
        instance = assigns(:user)
        expect(instance.firstname).to eq new_name
      end
      it "redirects to root on other manager" do
        new_name = "MyNewFirstName"
        put :update, params: {id: @non_manager.id, user: {firstname: new_name}}
        expect(response).to redirect_to( authenticated_root_path )
      end
      it "redirects to root on admin" do
        new_name = "MyNewFirstName"
        put :update, params: {id: @admin.id, user: {firstname: new_name}}
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "DELETE #destroy" do
      it "redirects to cancel_user_registration on self" do
        delete :destroy, params: {id: @manager.id}
        expect(response).to redirect_to( cancel_user_registration_path )
      end
      it "deletes own member" do
        delete :destroy, params: {id: @member.id}
        cnt = User.where(id: @member.id).count
        expect(cnt).to eq 0
      end
      it "redirects to users on own member" do
        delete :destroy, params: {id: @member.id}
        expect(response).to redirect_to( users_path )
      end
      it "does not delete other manager" do
        delete :destroy, params: {id: @non_manager.id}
        cnt = User.where(id: @non_manager.id).count
        expect(cnt).to eq 1
      end
      it "redirects to root on other manager" do
        delete :destroy, params: {id: @non_manager.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
      it "does not delete admin" do
        delete :destroy, params: {id: @admin.id}
        cnt = User.where(id: @admin.id).count
        expect(cnt).to eq 1
      end
      it "redirects to root on admin" do
        delete :destroy, params: {id: @admin.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
  end

  context "Admin CRUD" do
    before do
      @member = create(:user)
      @non_member = create(:user)
      @manager = create(:user, role: "manager")
      @non_manager = create(:user, role: "manager")
      @admin = create(:user, role: "admin")
      @winery = create(:winery)
      @club = create(:club, winery: @winery)
      @membership = create(:membership, club: @club, user: @member)
      @account = create(:account, user: @manager, winery: @winery)
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in @admin, scope: :user
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      it "renders index" do
        get :index
        expect(response).to render_template(:admin_index)
      end
    end
    describe "GET #show" do
      it "returns http success on self" do
        get :show, params: {id: @admin.id}
        expect(response).to have_http_status(:success)
      end
      it "renders the #show view on self" do
        get :show, params: {id: @admin.id}
        expect(response).to render_template :show
      end
      it "returns http success on member" do
        get :show, params: {id: @admin.id}
        expect(response).to have_http_status(:success)
      end
      it "renders the #show view on member" do
        get :show, params: {id: @admin.id}
        expect(response).to render_template :show
      end
      it "returns http success on manager" do
        get :show, params: {id: @manager.id}
        expect(response).to have_http_status(:success)
      end
      it "renders the #show view on manager" do
        get :show, params: {id: @manager.id}
        expect(response).to render_template :show
      end
    end
    describe "GET #edit" do
      it "redirects to edit_user_registration_path on self" do
        get :edit, params: {id: @admin.id}
        expect(response).to redirect_to( edit_user_registration_path )
      end
      it "returns http success on member" do
        get :edit, params: {id: @member.id}
        expect(response).to have_http_status(:success)
      end
      it "renders edit member" do
        get :edit, params: {id: @member.id}
        expect(response).to render_template(:edit)
      end
      it "returns http success on manager" do
        get :edit, params: {id: @manager.id}
        expect(response).to have_http_status(:success)
      end
      it "renders edit member" do
        get :edit, params: {id: @manager.id}
        expect(response).to render_template(:edit)
      end
    end
    describe "GET #update" do
      it "redirects to edit_user_registration_path on self" do
        new_name = "MyNewFirstName"
        put :update, params: {id: @admin.id, user: {firstname: new_name}}
        expect(response).to redirect_to( edit_user_registration_path )
      end
      it "redirects to #show on member" do
        new_name = "MyNewFirstName"
        put :update, params: {id: @member.id, user: {firstname: new_name}}
        expect(response).to redirect_to(@member)
      end
      it "updates member" do
        new_name = "MyNewFirstName"
        put :update, params: {id: @member.id, user: {firstname: new_name}}
        instance = assigns(:user)
        expect(instance.firstname).to eq new_name
      end
      it "redirects to #show on manager" do
        new_name = "MyNewFirstName"
        put :update, params: {id: @manager.id, user: {firstname: new_name}}
        expect(response).to redirect_to(@manager)
      end
      it "updates manager" do
        new_name = "MyNewFirstName"
        put :update, params: {id: @manager.id, user: {firstname: new_name}}
        instance = assigns(:user)
        expect(instance.firstname).to eq new_name
      end
    end
    describe "DELETE #destroy" do
      it "redirects to cancel_user_registration on self" do
        delete :destroy, params: {id: @admin.id}
        expect(response).to redirect_to( cancel_user_registration_path )
      end
      it "deletes member" do
        delete :destroy, params: {id: @member.id}
        cnt = User.where(id: @member.id).count
        expect(cnt).to eq 0
      end
      it "redirects to users on member" do
        delete :destroy, params: {id: @member.id}
        expect(response).to redirect_to( users_path )
      end
      it "deletes manager" do
        delete :destroy, params: {id: @manager.id}
        cnt = User.where(id: @manager.id).count
        expect(cnt).to eq 0
      end
      it "redirects to users on manager" do
        delete :destroy, params: {id: @manager.id}
        expect(response).to redirect_to( users_path )
      end
    end
  end


end
