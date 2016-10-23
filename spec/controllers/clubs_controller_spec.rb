require 'rails_helper'

RSpec.describe ClubsController, type: :controller do

  let(:member){ create(:user) }
  let(:non_member){ create(:user) }
  let(:manager){ create(:user, role: "manager") }
  let(:non_manager){ create(:user, role: "manager") }
  let(:admin){ create(:user, role: "admin") }
  let(:winery){ create(:winery) }
  let(:club){ create(:club, winery: winery) }
  let(:membership){ create(:membership, club: club, user: member) }
  let(:account){ create(:account, user: manager, winery: winery) }

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
        get :edit, params: { id: club.id }
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "PUT #update" do
      it "returns http redirect" do
        club_name = "New Name"
        club_desc = "New Description"
        put :update, params: { id: club.id, club: {name: club_name, description: club_desc} }
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
        new_club = create(:club)
        expect{post :create, params: {
          club: { name: new_club.name,
                    description: new_club.description
                  }
          }}.to change(Club, :count).by(0)
      end
      it "returns http redirect" do
        new_club = create(:club)
        post :create, params: {
          club: {
                  name: new_club.name,
                  description: new_club.description
                }
        }
        expect(response).to redirect_to( new_user_session_path )
      end
    end
    describe "DELETE #destroy" do
      it "it does not destroy club" do
        delete :destroy, params: {id: club.id}
        count = Club.where({id: club.id}).size
        expect(count).to eq 1
      end
      it "returns http redirect to sign_in" do
        delete :destroy, params: {id: club.id}
        expect(response).to redirect_to( new_user_session_path )
      end
    end
  end # end Guest CRUD

  shared_examples_for "members" do
    context "Member CRUD" do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:member]
        sign_in member, scope: :user
      end
      describe "GET #index" do
        it "redirects to root" do
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
          get :edit, params: { id: club.id }
          expect(response).to redirect_to( authenticated_root_path )
        end
      end
      describe "PUT #update" do
        it "returns http redirect" do
          club_name = "New Name"
          club_desc = "New Description"
          put :update, params: { id: club.id, club: {name: club_name, description: club_desc} }
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
        it "does not create new club for user" do
          new_club = create(:club)
          expect{post :create, params: {
            club: { name: new_club.name,
                      description: new_club.description
                    }
            }}.to change(Club, :count).by(0)
        end
        it "returns http redirect" do
          new_club = create(:club)
          post :create, params: {
            club: {
                    name: new_club.name,
                    description: new_club.description
                  }
          }
          expect(response).to redirect_to( authenticated_root_path )
        end
      end
      describe "DELETE #destroy" do
        it "it does not destroy club" do
          delete :destroy, params: {id: club.id}
          count = Club.where({id: club.id}).size
          expect(count).to eq 1
        end
        it "returns http redirect to sign_in" do
          delete :destroy, params: {id: club.id}
          expect(response).to redirect_to( authenticated_root_path )
        end
      end
    end # end Member CRUD
  end

  shared_examples_for "managers" do
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
          get :show, params: {id: club.id}
          expect(response).to have_http_status(:success)
        end
        it "renders the #show view" do
          get :show, params: {id: club.id}
          expect(response).to render_template :show
        end
      end
      describe "GET #edit" do
        it "returns http success" do
          get :edit, params: { id: club.id }
          expect(response).to have_http_status(:success)
        end
        it "renders #edit view" do
          get :edit, params: { id: club.id }
          expect(response).to render_template :edit
        end
      end
      describe "PUT #update" do
        it "updates winery" do
          club_name = "New Name"
          club_desc = "New Description"
          put :update, params: { id: club.id, club: {name: club_name, description: club_desc} }
          c_instance = assigns(:club)
          expect(c_instance.name).to eq club_name
          expect(c_instance.description).to eq club_desc
        end
        it "redirects to winery #show" do
          club_name = "New Name"
          club_desc = "New Description"
          put :update, params: { id: club.id, club: {name: club_name, description: club_desc} }
          expect(response).to redirect_to( club_path )
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
          new_club = create(:club)
          expect{post :create, params: {
            club: { name: new_club.name,
                      description: new_club.description
                    }
            }}.to change(Club, :count).by(1)
        end
        it "returns http redirect to show" do
          new_club = create(:club)
          post :create, params: {
            club: {
                    name: new_club.name,
                    description: new_club.description
                  }
          }
          expect(response).to redirect_to( Club.last )
        end
      end
      describe "DELETE #destroy" do
        it "it does not destroy club" do
          delete :destroy, params: {id: club.id}
          count = Club.where({id: club.id}).size
          expect(count).to eq 0
        end
        it "returns http redirect to sign_in" do
          delete :destroy, params: {id: club.id}
          expect(response).to redirect_to( clubs_path )
        end
      end
    end # end Manager CRUD
  end # end managers shared example

  context "Non-Manager CRUD" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:manager]
      my_account = account # need to initialize account to associate winery w/user
      sign_in non_manager, scope: :user
    end
    describe "GET #index" do
      it_behaves_like "managers"
    end
    describe "GET #show" do
      it_behaves_like "members"
    end
    describe "GET #edit" do
      it_behaves_like "members"
    end
    describe "PUT #update" do
      it_behaves_like "members"
    end
    describe "GET #new" do
      it_behaves_like "members"
    end
    describe "POST #create" do
      it_behaves_like "members"
    end
    describe "DELETE #destroy" do
      it_behaves_like "members"
    end
  end # end Non-Manager CRUD


  context "Admin CRUD" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in admin, scope: :user
    end
    describe "GET #index" do
      it_behaves_like "managers"
    end
    describe "GET #show" do
      it_behaves_like "managers"
    end
    describe "GET #edit" do
      it_behaves_like "managers"
    end
    describe "PUT #update" do
      it_behaves_like "managers"
    end
    describe "GET #new" do
      it_behaves_like "managers"
    end
    describe "POST #create" do
      it_behaves_like "managers"
    end
    describe "DELETE #destroy" do
      it_behaves_like "managers"
    end
  end # end Admin CRUD
end
