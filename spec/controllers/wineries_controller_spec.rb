require 'rails_helper'

RSpec.describe WineriesController, type: :controller do

  let(:winery){ create(:winery) }

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
      get :show, id: winery.id
      expect(response).to have_http_status(:success)
    end
    it "renders the #show view" do
      get :show, id: winery.id
      expect(response).to render_template :show
    end
  end

end
