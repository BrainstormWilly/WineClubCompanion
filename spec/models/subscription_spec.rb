require 'rails_helper'

RSpec.describe Subscription, type: :model do

  let!(:user){ create(:user) }
  let!(:winery){ create(:winery) }
  let!(:activity){ create(:activity, winery: winery) }
  let!(:delivery){ create(:delivery, activity: activity) }
  let(:subscription){ create(:subscription, user: user, delivery: delivery) }

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:delivery_id) }


  describe "attributes" do
    it "should have user, delivery attributes" do
      expect(subscription).to have_attributes(user: user, delivery: delivery)
    end
    it "default activated should be false" do
      expect(subscription.activated).to be_falsey
    end
  end

end
