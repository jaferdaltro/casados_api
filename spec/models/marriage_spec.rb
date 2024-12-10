require 'rails_helper'

RSpec.describe Marriage, type: :model do
  it { is_expected.to belong_to :husband }
  it { is_expected.to belong_to :wife }
  it { is_expected.to belong_to :address }
  it { is_expected.to validate_presence_of(:is_member) }
  it { is_expected.to validate_presence_of(:days_availability) }

  describe "validations" do
    let(:husband) { create(:user, gender: "male") }
    let(:wife) { create(:user, gender: "female") }
    subject { build(:marriage, husband: husband, wife: wife) }

    describe "#should_be_different_users" do
      it "should be valid" do
        expect(subject).to be_valid
      end

      context "when husband and wife are the same user" do
        let(:wife) { husband }

        it "should not be valid" do
          expect(subject).not_to be_valid
        end
      end
    end
  end
end
