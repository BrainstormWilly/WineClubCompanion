require 'rails_helper'

RSpec.describe WineriesController, type: :controller do

  let(:member){ create(:user) }
  let(:manager){ create(:user, role: "manager") }
  let(:non_manager){ create(:user, role: "manager") }
  let(:admin){ create(:user, role: "admin") }
  let(:winery){ create(:winery) }
  let(:account){ create(:account, user: manager, winery: winery)}

  context "Guest CRUD" do
    describe "GET #index" do
      it "returns http redirect to sign_in" do
        get :index
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "GET #show" do
      it "returns http redirect to sign_in" do
        get :index
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "GET #edit" do
      it "returns http redirect to sign_in" do
        get :edit, params: { id: winery.id }
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "PUT #update" do
      it "returns http redirect" do
        winery_name = "New Name"
        put :update, params: { id: winery.id, winery: {name: winery_name} }
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
      it "does not create new winery for user" do
        new_winery = create(:winery)
        expect{post :create, params: {
          winery: { name: new_winery.name,
                    address1: new_winery.address1,
                    address2: new_winery.address2,
                    city: new_winery.city,
                    state: new_winery.state,
                    zip: new_winery.zip,
                  }
          }}.to change(Winery, :count).by(0)
      end
      it "returns http redirect" do
        new_winery = create(:winery)
        post :create, params: {
          winery: { name: new_winery.name,
                    address1: new_winery.address1,
                    address2: new_winery.address2,
                    city: new_winery.city,
                    state: new_winery.state,
                    zip: new_winery.zip,
                  }
          }
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "DELETE #destroy" do
      it "it does not destroy winery" do
        delete :destroy, params: {id: winery.id}
        count = Winery.where({id: winery.id}).size
        expect(count).to eq 1
      end
      it "returns http redirect to sign_in" do
        delete :destroy, params: {id: winery.id}
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
    describe "GET #edit" do
      it "returns http redirect to root" do
        get :edit, params: { id: winery.id }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "PUT #update" do
      it "returns http redirect to root" do
        winery_name = "New Name"
        put :update, params: { id: winery.id, winery: {name: winery_name} }
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
      it "does not create new winery for user" do
        new_winery = create(:winery)
        expect{post :create, params: {
          winery: { name: new_winery.name,
                    address1: new_winery.address1,
                    address2: new_winery.address2,
                    city: new_winery.city,
                    state: new_winery.state,
                    zip: new_winery.zip,
                  }
          }}.to change(Winery, :count).by(0)
      end
      it "returns http redirect to root" do
        new_winery = create(:winery)
        post :create, params: {
          winery: { name: new_winery.name,
                    address1: new_winery.address1,
                    address2: new_winery.address2,
                    city: new_winery.city,
                    state: new_winery.state,
                    zip: new_winery.zip,
                  }
          }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "DELETE #destroy" do
      it "it does not destroy winery" do
        delete :destroy, params: {id: winery.id}
        count = Winery.where({id: winery.id}).size
        expect(count).to eq 1
      end
      it "returns http redirect root" do
        delete :destroy, params: {id: winery.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
  end # end Member CRUD

  context "Manager CRUD" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:manager]
      my_account = account # need to initialize account to associate winery w/user
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
        get :show, params: {id: winery.id}
        expect(response).to have_http_status(:success)
      end
      it "renders the #show view" do
        get :show, params: {id: winery.id}
        expect(response).to render_template :show
      end
    end
    describe "GET #edit" do
      it "returns http success" do
        get :edit, params: { id: winery.id }
        expect(response).to have_http_status(:success)
      end
      it "renders #edit view" do
        get :edit, params: { id: winery.id }
        expect(response).to render_template :edit
      end
    end
    describe "PUT #update" do
      it "updates winery" do
        winery_name = "New Name"
        put :update, params: { id: winery.id, winery: {name: winery_name} }
        w_instance = assigns(:winery)
        expect(w_instance.name).to eq winery_name
      end
      it "redirects to winery #show" do
        winery_name = "New Name"
        put :update, params: { id: winery.id, winery: {name: winery_name} }
        expect(response).to redirect_to( winery_path )
      end
    end
    describe "GET #new" do
      it "returns http redirect to root" do
        get :new
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "POST #create" do
      it "does not create new winery for user" do
        new_winery = create(:winery)
        expect{post :create, params: {
          winery: { name: new_winery.name,
                    address1: new_winery.address1,
                    address2: new_winery.address2,
                    city: new_winery.city,
                    state: new_winery.state,
                    zip: new_winery.zip,
                  }
          }}.to change(Winery, :count).by(0)
      end
      it "returns http redirect to root" do
        new_winery = create(:winery)
        post :create, params: {
          winery: { name: new_winery.name,
                    address1: new_winery.address1,
                    address2: new_winery.address2,
                    city: new_winery.city,
                    state: new_winery.state,
                    zip: new_winery.zip,
                  }
          }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "DELETE #destroy" do
      it "it destroys winery" do
        delete :destroy, params: {id: winery.id}
        count = Winery.where({id: winery.id}).size
        expect(count).to eq 0
      end
      it "returns http redirect to wineries" do
        delete :destroy, params: {id: winery.id}
        expect(response).to redirect_to( wineries_path )
      end
    end
  end # end Manager CRUD

  context "Non-Manager CRUD" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:manager]
      my_account = account # need to initialize account to associate winery w/user
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
        get :show, params: {id: winery.id}
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "GET #edit" do
      it "returns http redirect to root" do
        get :edit, params: { id: winery.id }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "PUT #update" do
      it "returns http redirect to root" do
        winery_name = "New Name"
        put :update, params: { id: winery.id, winery: {name: winery_name} }
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
      it "does not create new winery for user" do
        new_winery = create(:winery)
        expect{post :create, params: {
          winery: { name: new_winery.name,
                    address1: new_winery.address1,
                    address2: new_winery.address2,
                    city: new_winery.city,
                    state: new_winery.state,
                    zip: new_winery.zip,
                  }
          }}.to change(Winery, :count).by(0)
      end
      it "returns http redirect to root" do
        new_winery = create(:winery)
        post :create, params: {
          winery: { name: new_winery.name,
                    address1: new_winery.address1,
                    address2: new_winery.address2,
                    city: new_winery.city,
                    state: new_winery.state,
                    zip: new_winery.zip,
                  }
          }
        expect(response).to redirect_to( authenticated_root_path )
      end
    end
    describe "DELETE #destroy" do
      it "it does not destroy winery" do
        delete :destroy, params: {id: winery.id}
        count = Winery.where({id: winery.id}).size
        expect(count).to eq 1
      end
      it "returns http redirect to root" do
        delete :destroy, params: {id: winery.id}
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
    describe "GET #show" do
      it "returns http success" do
        get :show, params: {id: winery.id}
        expect(response).to have_http_status(:success)
      end
      it "renders the #show view" do
        get :show, params: {id: winery.id}
        expect(response).to render_template :show
      end
    end
    describe "GET #edit" do
      it "returns http success" do
        get :edit, params: { id: winery.id }
        expect(response).to have_http_status(:success)
      end
      it "renders #edit view" do
        get :edit, params: { id: winery.id }
        expect(response).to render_template :edit
      end
    end
    describe "PUT #update" do
      it "updates winery" do
        winery_name = "New Name"
        put :update, params: { id: winery.id, winery: {name: winery_name} }
        w_instance = assigns(:winery)
        expect(w_instance.name).to eq winery_name
      end
      it "redirects to winery #show" do
        winery_name = "New Name"
        put :update, params: { id: winery.id, winery: {name: winery_name} }
        expect(response).to redirect_to( winery_path )
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
      it "does not create new winery for user" do
        new_winery = create(:winery)
        expect{post :create, params: {
          winery: { name: new_winery.name,
                    address1: new_winery.address1,
                    address2: new_winery.address2,
                    city: new_winery.city,
                    state: new_winery.state,
                    zip: new_winery.zip
                  }
          }}.to change(Winery, :count).by(1)
      end
      it "returns http redirect to show" do
        new_winery = create(:winery)
        post :create, params: {
          winery: { name: new_winery.name,
                    address1: new_winery.address1,
                    address2: new_winery.address2,
                    city: new_winery.city,
                    state: new_winery.state,
                    zip: new_winery.zip
                  }
          }
        w = assigns(:winery)
        expect(response).to redirect_to( w )
      end
    end
    describe "DELETE #destroy" do
      it "it destroys winery" do
        delete :destroy, params: {id: winery.id}
        count = Winery.where({id: winery.id}).size
        expect(count).to eq 0
      end
      it "returns http redirect to index" do
        delete :destroy, params: {id: winery.id}
        expect(response).to redirect_to( wineries_path )
      end
    end
  end # end Admin CRUD

end
