require 'rails_helper'

RSpec.describe Voucher, type: :model do
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:expiration_at) }
  it { is_expected.to validate_presence_of(:is_available) }
  it { is_expected.to validate_presence_of(:lives) }
  it { is_expected.to validate_presence_of(:user_id) }

  describe "validations" do
    let(:expiration_at) { Time.now + 1.day }
    let(:is_available) { true }
    let(:lives) { 1 }
    subject { build(:voucher, expiration_at: expiration_at, is_available: is_available, lives: lives) }

    describe "#voucher_should_be_available" do
      it "should be valid" do
        expect(subject).to be_valid
      end
    end

    describe "#voucher_should_not_be_expired" do
     let(:expiration_at) { Time.now - 1.day }

      it "should not be valid" do
        expect(subject).not_to be_valid
      end
    end

    describe "#voucher_should_have_life" do
      let(:lives) { 0 }

      it "should not be valid" do
        expect(subject).not_to be_valid
      end
    end
  end
end
