require 'rails_helper'

RSpec.describe Activity, type: :model do

  let!(:winery){ create(:winery) }
  let(:activity){ create(:activity, winery: winery)}

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(1) }
  it { is_expected.to validate_presence_of(:activity_type) }
  it { is_expected.to validate_length_of(:activity_type).is_at_least(1) }
  it { is_expected.to validate_presence_of(:winery_id) }

  describe "attributes" do
    it "should have winery attributes" do
      expect(activity).to have_attributes(winery: winery)
    end
  end

end
