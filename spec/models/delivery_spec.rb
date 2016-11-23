require 'rails_helper'

RSpec.describe Delivery, type: :model do

  let!(:winery){ create(:winery) }
  let!(:activity){ create(:activity, winery: winery) }
  let(:delivery){ create(:delivery, activity: activity) }

  it { is_expected.to validate_presence_of(:activity_id) }
  it { is_expected.to validate_presence_of(:channel) }

  describe "attributes" do
    it "should have activity attributes" do
      expect(delivery).to have_attributes(activity: activity)
    end
    it "default channel should be email" do
      expect(delivery.channel).to eq "email"
    end
  end
end
