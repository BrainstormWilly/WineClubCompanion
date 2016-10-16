require 'rails_helper'

RSpec.describe MembershipsController, type: :controller do

  let( :member ) { create(:user) }
  let( :winery ) { create(:winery) }
  let( :club ) { create(:club, winery: winery) }
  let( :membership ) { create(:membership, club: club, user: member)}

  context "Guest CRUD" do
    describe "GET #index" do
      it "returns http redirect" do
        get :index
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "GET #show" do
      it "returns http redirect" do
        get :show, params: { id: membership.id }
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "GET #edit" do
      it "returns http redirect" do
        get :edit, params: { id: membership.id }
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "PUT #update" do
      it "returns http redirect" do
        put :update, params: { id: membership.id, membership: {registered: true} }
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "GET #new" do
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "POST #create" do
      it "does not create new club for user" do
        new_club = create(:club, winery: winery)
        new_user = create(:user)
        expect{post :create, params: { membership: {club_id: new_club.id, user_id: new_user.id}}}.to change(Membership, :count).by(0)
      end
      it "returns http redirect" do
        new_club = create(:club, winery: winery)
        new_user = create(:user)
        post :create, params: { membership: {club_id: new_club.id, user_id: new_user.id} }
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "DELETE #destroy" do
      it "it does not destroy membership" do
        delete :destroy, params: {id: membership.id}
        count = Membership.where({id: membership.id}).size
        expect(count).to eq 1
      end
      it "returns http redirect sign in" do
        delete :destroy, params: {id: membership.id}
        expect(response).to redirect_to( new_user_session_path )
      end
    end
  end # end Guest CRUD

  context "Non-Member's CRUD" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:member]
      non_member = create(:user)
      sign_in non_member, scope: :user
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status :success
      end
      it "renders index" do
        get :index
        expect(response).to render_template :member_index
      end
    end
    describe "GET #show" do
      it "returns http redirect" do
        get :show, params: { id: membership.id }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "GET #edit" do
      it "returns http redirect" do
        get :edit, params: { id: membership.id }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "PUT #update" do
      it "returns http redirect" do
        put :update, params: { id: membership.id, membership: {registered: true} }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "GET #new" do
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "POST #create" do
      it "does not create new club for member" do
        new_club = create(:club, winery: winery)
        expect{post :create, params: { membership: {club_id: new_club.id, user_id: member.id}}}.to change(Membership, :count).by(0)
      end
      it "returns http redirect" do
        new_club = create(:club, winery: winery)
        post :create, params: { membership: {club_id: new_club.id, user_id: member.id} }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "DELETE #destroy" do
      it "it does not destroy membership" do
        delete :destroy, params: {id: membership.id}
        count = Membership.where({id: membership.id}).size
        expect(count).to eq 1
      end
      it "returns http redirect to root" do
        delete :destroy, params: {id: membership.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
  end # end Non-Member's CRUD

  context "Member's CRUD" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:member]
      @member = create(:user)
      membership.user = @member
      membership.save
      sign_in @member, scope: :user
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status :success
      end
      it "renders member index" do
        get :index
        expect(response).to render_template :member_index
      end
    end
    describe "GET #show" do
      it "returns http success" do
        get :show, params: { id: membership.id }
        expect(response).to have_http_status :success
      end
      it "renders show" do
        get :show, params: { id: membership.id }
        expect(response).to render_template :show
      end
      it "assigns membership" do
        get :show, params: { id: membership.id }
        m_instance = assigns(:membership)

        expect(m_instance.id).to eq membership.id
        expect(m_instance.club).to eq club
        expect(m_instance.user).to eq @member
      end
    end
    describe "GET #edit" do
      it "returns http success" do
        get :edit, params: { id: membership.id }
        expect(response).to have_http_status(:success)
      end
      it "renders the #edit template" do
        get :edit, params: { id: membership.id }
        expect(response).to render_template :edit
      end
      it "assigns membership" do
        get :edit, params: { id: membership.id }
        m_instance = assigns(:membership)

        expect(m_instance.id).to eq membership.id
        expect(m_instance.registered).to eq membership.registered
      end
    end
    describe "PUT #update" do
      it "updates membership" do
        put :update, params: { id: membership.id, membership: {registered: true} }
        m_instance = assigns(:membership)
        expect(m_instance.registered).to be_truthy
      end
      it "redirects to membership #show" do
        put :update, params: { id: membership.id, membership: {registered: true} }
        expect(response).to redirect_to( membership_path )
      end
    end
    describe "GET #new" do
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "POST #create" do
      it "does not create new club for member" do
        new_club = create(:club, winery: winery)
        expect{post :create, params: { membership: {club_id: new_club.id, user_id: member.id}}}.to change(Membership, :count).by(0)
      end
      it "returns http redirect" do
        new_club = create(:club, winery: winery)
        post :create, params: { membership: {club_id: new_club.id, user_id: member.id} }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "DELETE #destroy" do
      it "it does not destroy membership" do
        delete :destroy, params: {id: membership.id}
        count = Membership.where({id: membership.id}).size
        expect(count).to eq 1
      end
      it "returns http redirect to root" do
        delete :destroy, params: {id: membership.id}
        expect(response).to redirect_to( root_path )
      end
    end
  end # end Member's membership CRUD

  context "Manager's CRUD" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:manager]
      manager = create(:user, role: "manager")
      account = create(:account, user: manager, winery: winery)
      sign_in manager, scope: :user
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status :success
      end
      it "renders authorized index" do
        get :index
        expect(response).to render_template :authorized_index
      end
    end
    describe "GET #show" do
      it "returns http success" do
        get :show, params: { id: membership.id }
        expect(response).to have_http_status :success
      end
      it "renders show" do
        get :show, params: { id: membership.id }
        expect(response).to render_template :show
      end
      it "assigns membership" do
        get :show, params: { id: membership.id }
        m_instance = assigns(:membership)

        expect(m_instance.id).to eq membership.id
        expect(m_instance.club).to eq club
        expect(m_instance.user).to eq member
      end
    end
    describe "GET #edit" do
      it "returns http success" do
        get :edit, params: { id: membership.id }
        expect(response).to have_http_status(:success)
      end
      it "assigns public wiki to be updated to @wiki" do
        get :edit, params: { id: membership.id }
        m_instance = assigns(:membership)
        expect(m_instance.id).to eq membership.id
        expect(m_instance.registered).to eq membership.registered
      end
    end
    describe "PUT #update" do
      it "updates membership" do
        put :update, params: { id: membership.id, membership: {registered: true} }
        m_instance = assigns(:membership)
        expect(m_instance.registered).to be_truthy
      end
      it "redirects to membership #show" do
        put :update, params: { id: membership.id, membership: {registered: true} }
        expect(response).to redirect_to( membership_path )
      end
    end
    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
      it "renders the #new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end
    describe "POST #create" do
      it "creates new club for member" do
        new_club = create(:club, winery: winery)
        expect{post :create, params: { membership: {club_id: new_club.id, user_id: member.id}}}.to change(Membership, :count).by(1)
      end
      it "redirects to members membership #show" do
        new_club = create(:club, winery: winery)
        post :create, params: { membership: {club_id: new_club.id, user_id: member.id} }
        expect(response).to redirect_to( Membership.last )
      end
      it "does not create new club for other winery" do
        new_winery = create(:winery)
        new_club = create(:club, winery: new_winery)
        expect{post :create, params: { membership: {club_id: new_club.id, user_id: member.id}}}.to change(Membership, :count).by(0)
      end
      it "redirects to root when creating other winery's membership" do
        new_winery = create(:winery)
        new_club = create(:club, winery: new_winery)
        post :create, params: { membership: {club_id: new_club.id, user_id: member.id} }
        expect(response).to redirect_to( root_path )
      end
    end
    describe "DELETE #destroy" do
      it "destroys membership" do
        delete :destroy, params: {id: membership.id}
        count = Membership.where({id: membership.id}).size
        expect(count).to eq 0
      end
      it "returns http redirect to memberships" do
        delete :destroy, params: {id: membership.id}
        expect(response).to redirect_to( memberships_path )
      end
    end
  end # end Manager's CRUD

  context "Non-Manager's CRUD" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:manager]
      manager = create(:user, role: "manager")
      sign_in manager, scope: :user
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status :success
      end
      it "renders authorized index" do
        get :index
        expect(response).to render_template :authorized_index
      end
    end
    describe "GET #show" do
      it "returns http redirect" do
        get :show, params: { id: membership.id }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "GET #edit" do
      it "returns http redirect" do
        get :edit, params: { id: membership.id }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "PUT #update" do
      it "returns http redirect" do
        put :update, params: { id: membership.id, membership: {registered: true} }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
      it "renders the #new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end
    describe "POST #create" do
      it "does not create new club for member" do
        new_club = create(:club, winery: winery)
        expect{post :create, params: { membership: {club_id: new_club.id, user_id: member.id}}}.to change(Membership, :count).by(0)
      end
      it "redirects to root" do
        new_club = create(:club, winery: winery)
        post :create, params: { membership: {club_id: new_club.id, user_id: member.id} }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "DELETE #destroy" do
      it "it does not destroy membership" do
        delete :destroy, params: {id: membership.id}
        count = Membership.where({id: membership.id}).size
        expect(count).to eq 1
      end
      it "returns http redirect to root" do
        delete :destroy, params: {id: membership.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
  end # end Non-Manager's membership CRUD

  context "Admin's CRUD" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      admin = create(:user, role: "admin")
      sign_in admin, scope: :user
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status :success
      end
      it "renders authorized_index" do
        get :index
        expect(response).to render_template :authorized_index
      end
    end
    describe "GET #show" do
      it "returns http success" do
        get :show, params: { id: membership.id }
        expect(response).to have_http_status :success
      end
      it "renders show" do
        get :show, params: { id: membership.id }
        expect(response).to render_template :show
      end
      it "assigns membership" do
        get :show, params: { id: membership.id }
        m_instance = assigns(:membership)

        expect(m_instance.id).to eq membership.id
        expect(m_instance.club).to eq club
        expect(m_instance.user).to eq member
      end
    end
    describe "GET #edit" do
      it "returns http success" do
        get :edit, params: { id: membership.id }
        expect(response).to have_http_status(:success)
      end
      it "assigns public wiki to be updated to @wiki" do
        get :edit, params: { id: membership.id }
        m_instance = assigns(:membership)
        expect(m_instance.id).to eq membership.id
        expect(m_instance.registered).to eq membership.registered
      end
    end
    describe "PUT #update" do
      it "updates membership" do
        put :update, params: { id: membership.id, membership: {registered: true} }
        m_instance = assigns(:membership)
        expect(m_instance.registered).to be_truthy
      end
      it "redirects to membership #show" do
        put :update, params: { id: membership.id, membership: {registered: true} }
        expect(response).to redirect_to( membership_path )
      end
    end
    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
      it "renders the #new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end
    describe "POST #create" do
      it "creates new club for member" do
        new_club = create(:club, winery: winery)
        expect{post :create, params: { membership: {club_id: new_club.id, user_id: member.id}}}.to change(Membership, :count).by(1)
      end
      it "redirects to member's membership #show" do
        new_club = create(:club, winery: winery)
        post :create, params: { membership: {club_id: new_club.id, user_id: member.id} }
        expect(response).to redirect_to( Membership.last )
      end
      it "creates new club for other winery" do
        new_winery = create(:winery)
        new_club = create(:club, winery: new_winery)
        expect{post :create, params: { membership: {club_id: new_club.id, user_id: member.id}}}.to change(Membership, :count).by(1)
      end
      it "redirects to new club's membership #show" do
        new_winery = create(:winery)
        new_club = create(:club, winery: new_winery)
        post :create, params: { membership: {club_id: new_club.id, user_id: member.id} }
        expect(response).to redirect_to( Membership.last )
      end
    end
    describe "DELETE #destroy" do
      it "destroys membership" do
        delete :destroy, params: {id: membership.id}
        count = Membership.where({id: membership.id}).size
        expect(count).to eq 0
      end
      it "returns http redirect to memberships" do
        delete :destroy, params: {id: membership.id}
        expect(response).to redirect_to( memberships_path )
      end
    end
  end # end Admins's CRUD



end
