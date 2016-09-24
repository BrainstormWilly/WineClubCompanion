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
  end

end
