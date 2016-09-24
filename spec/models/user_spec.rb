require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user) }

  it { is_expected.to validate_presence_of(:firstname) }
  it { is_expected.to validate_length_of(:firstname).is_at_least(1) }
  it { is_expected.to validate_presence_of(:lastname) }
  it { is_expected.to validate_length_of(:lastname).is_at_least(1) }
  it { is_expected.to validate_presence_of(:role) }


  describe "attributes" do
    it "should have name, role, and email attributes" do
      expect(user).to have_attributes(firstname: user.firstname, lastname: user.lastname, email: user.email, role: user.role)
    end

    it "responds to role" do
      expect(user).to respond_to(:role)
    end

    it "responds to member?" do
      expect(user).to respond_to(:member?)
    end

    it "responds to admin?" do
      expect(user).to respond_to(:admin?)
    end

    it "responds to winery?" do
      expect(user).to respond_to(:winery?)
    end
  end

  describe "roles" do
    it "is member by default" do
      expect(user.role).to eq("member")
    end

    context "member user" do
      it "returns true for #member?" do
        expect(user.member?).to be_truthy
      end

      it "returns false for #admin?" do
        expect(user.admin?).to be_falsey
      end

      it 'returns false for #winery' do
        expect(user.winery?).to be_falsey
      end
    end

    context "winery user" do
      before do
        user.winery!
      end

      it "returns false for #member?" do
        expect(user.member?).to be_falsey
      end

      it "returns false for #admin?" do
        expect(user.admin?).to be_falsey
      end

      it 'returns true for #winery?' do
        expect(user.winery?).to be_truthy
      end
    end

    context "admin user" do
      before do
        user.admin!
      end

      it "returns false for #member?" do
        expect(user.member?).to be_falsey
      end

      it "returns true for #admin?" do
        expect(user.admin?).to be_truthy
      end

      it 'returns false for #winery?' do
        expect(user.winery?).to be_falsey
      end
    end
  end

  describe "invalid user" do
    let(:user_with_invalid_firstname) { build(:user, firstname:"") }
    let(:user_with_invalid_lastname) { build(:user, lastname:"") }
    let(:user_with_invalid_email) { build(:user, email:"") }

    it "should be an invalid user due to blank firstname" do
      expect(user_with_invalid_firstname).to_not be_valid
    end

    it "should be an invalid user due to blank lastname" do
      expect(user_with_invalid_lastname).to_not be_valid
    end

    it "should be an invalid user due to blank email" do
      expect(user_with_invalid_email).to_not be_valid
    end
  end

end
