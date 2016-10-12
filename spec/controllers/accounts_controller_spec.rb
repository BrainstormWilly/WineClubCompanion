require 'rails_helper'

RSpec.describe AccountsController, type: :controller do

  let( :manager ) { create(:user, role:"manager") }
  let( :admin ) { create(:user, role:"admin") }
  let( :member ) { create(:user) }
  let( :winery ) { create(:winery) }
  let( :account ) { create(:account, winery: winery, user: manager)}

  context "Guest CRUD" do
    describe "GET #index" do
      it "returns http redirect to sign_in" do
        get :index
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "GET #show" do
      it "returns http redirect to sign_in" do
        get :show, params: {id: account.id}
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "GET #new" do
      it "returns http redirect to sign_in" do
        get :new
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "POST #create" do
      it "does not create new account for manager" do
        new_winery = create(:winery)
        expect{post :create, params: { account: {winery_id: new_winery.id, user_id: manager.id}}}.to change(Account, :count).by(0)
      end
      it "returns http redirect to sign_in" do
        new_winery = create(:winery)
        post :create, params: { account: {winery_id: new_winery.id, user_id: manager.id} }
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "DELETE #destroy" do
      it "does not delete account" do
        delete :destroy, params: { id: account.id }
        count = Account.where(id: account.id).count
        expect(count).to eq 1
      end
      it "returns http redirect to sign_in" do
        delete :destroy, params: { id: account.id }
        expect(response).to redirect_to( new_user_session_path )
      end
    end
  end # end Guest CRUD

  context "Member CRUD" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:member]
      sign_in member, scope: :user
    end
    describe "GET #index" do
      it "returns http redirect to root" do
        get :index
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "GET #show" do
      it "returns http redirect to root" do
        get :index
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "GET #new" do
      it "returns http redirect to root" do
        get :new
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "POST #create" do
      it "does not create new account for manager" do
        new_winery = create(:winery)
        expect{post :create, params: { account: {winery_id: new_winery.id, user_id: manager.id}}}.to change(Account, :count).by(0)
      end
      it "returns http redirect to root" do
        new_winery = create(:winery)
        post :create, params: {winery_id: new_winery.id, user_id: manager.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "DELETE #destroy" do
      it "does not delete account" do
        delete :destroy, params: { id: account.id }
        count = Account.where(id: account.id).count
        expect(count).to eq 1
      end
      it "returns http redirect to root" do
        delete :destroy, params: { id: account.id }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
  end # end Member CRUD

  context "Manager CRUD" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:manager]
      sign_in manager, scope: :user
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      it "renders index" do
        get :index
        expect(response).to render_template(:index)
      end
    end
    describe "GET #show" do
      it "returns http success" do
        get :show, params: {id: account.id}
        expect(response).to have_http_status(:success)
      end
      it "renders #show" do
        get :show, params: {id: account.id}
        expect(response).to render_template(:show)
      end
    end
    describe "GET #new" do
      it "returns http redirect to root" do
        get :new
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "POST #create" do
      it "does not new account for manager" do
        new_winery = create(:winery)
        expect{post :create, params: { account: {winery_id: new_winery.id, user_id: manager.id}}}.to change(Account, :count).by(0)
      end
      it "returns http redirect to root" do
        new_winery = create(:winery)
        post :create, params: { account: {winery_id: new_winery.id, user_id: manager.id} }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "DELETE #destroy" do
      it "does not delete account" do
        delete :destroy, params: { id: account.id }
        count = Account.where(id: account.id).count
        expect(count).to eq 1
      end
      it "returns http redirect to root" do
        delete :destroy, params: { id: account.id }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
  end # end Manager CRUD

  context "Non-Manager CRUD" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:manager]
      non_manager = create(:user, role: "manager")
      sign_in non_manager, scope: :user
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      it "renders index" do
        get :index
        expect(response).to render_template(:index)
      end
    end
    describe "GET #show" do
      it "returns http redirect to root" do
        get :show, params: {id: account.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "GET #new" do
      it "returns http redirect to root" do
        get :new
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "POST #create" do
      it "does not new account for manager" do
        new_winery = create(:winery)
        expect{post :create, params: { account: {winery_id: new_winery.id, user_id: manager.id}}}.to change(Account, :count).by(0)
      end
      it "returns http redirect to root" do
        new_winery = create(:winery)
        post :create, params: { account: {winery_id: new_winery.id, user_id: manager.id} }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "DELETE #destroy" do
      it "does not delete account" do
        delete :destroy, params: { id: account.id }
        count = Account.where(id: account.id).count
        expect(count).to eq 1
      end
      it "returns http redirect to root" do
        delete :destroy, params: { id: account.id }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
  end # end Non-Manager CRUD

  context "Admin CRUD" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in admin, scope: :user
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      it "renders index" do
        get :index
        expect(response).to render_template(:index)
      end
    end
    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
      it "renders #new" do
        get :new
        expect(response).to render_template(:new)
      end
    end
    describe "GET #show" do
      it "returns http success" do
        get :show, params: {id: account.id}
        expect(response).to have_http_status(:success)
      end
      it "renders #show" do
        get :show, params: {id: account.id}
        expect(response).to render_template(:show)
      end
    end
    describe "POST #create" do
      it "creates new account for manager" do
        new_winery = create(:winery)
        expect{post :create, params: { account: {winery_id: new_winery.id, user_id: manager.id}}}.to change(Account, :count).by(1)
      end
      it "redirects to manager's account #show" do
        new_winery = create(:winery)
        post :create, params: { account: {winery_id: new_winery.id, user_id: manager.id} }
        expect(response).to redirect_to( Account.last )
      end
    end
    describe "DELETE #destroy" do
      it "deletes account" do
        delete :destroy, params: { id: account.id }
        count = Account.where(id: account.id).count
        expect(count).to eq 0
      end
      it "redirects to manager's accounts" do
        delete :destroy, params: { id: account.id }
        expect(response).to redirect_to( accounts_path )
      end
    end
  end # end Admin CRUD


end
