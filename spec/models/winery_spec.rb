require 'rails_helper'

RSpec.describe Winery, type: :model do

  let(:winery) { create(:winery) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(1) }


  describe "attributes" do
    it "should have name" do
      expect(winery).to have_attributes(name: winery.name)
    end
  end

end
