require 'rails_helper'

RSpec.describe AccountsController, type: :controller do

  let( :manager ) { create(:user, role:"manager") }
  let( :winery ) { create(:winery) }
  let( :account ) { create(:account, winery: winery, user: manager)}

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

end
