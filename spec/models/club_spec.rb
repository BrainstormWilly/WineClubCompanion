require 'rails_helper'

RSpec.describe Club, type: :model do
  let(:winery) { create(:winery) }
  let(:club) { create(:club, winery: winery) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(1) }

  describe "attributes" do
    it "should have name, winery attributes" do
      expect(club).to have_attributes(name: club.name, winery: club.winery)
    end
  end

end
