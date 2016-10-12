require 'rails_helper'

RSpec.describe Membership, type: :model do

  let(:winery) { create(:winery) }
  let(:club) { create(:club, winery: winery) }
  let(:user) { create(:user) }
  let(:membership) { create(:membership, club: club, user: user) }

  describe "attributes" do
    it "should have club, user attributes" do
      expect(membership).to have_attributes(club: membership.club, user: membership.user)
    end
    it "should init as unregistered" do
      expect(membership.registered).to be_falsey
    end
    it "responds to registered?" do
      expect(membership).to respond_to(:registered?)
    end
  end

end
