require 'rails_helper'

RSpec.describe Account, type: :model do

  let(:winery) { create(:winery) }
  let(:user) { create(:user) }
  let(:account) { create(:account, winery: winery, user: user) }

  describe "attributes" do
    it "should have club, user attributes" do
      expect(account).to have_attributes(winery: account.winery, user: account.user)
    end
  end

end
