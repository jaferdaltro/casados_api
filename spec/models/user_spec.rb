require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:cpf) }
  it { is_expected.to validate_presence_of(:phone) }
  it { is_expected.to define_enum_for(:role) }

  describe "validations" do
    subject { build(:user) }
    describe "#user_should_have_correct_cpf" do
      it "should be valid" do
        expect(subject).to be_valid
      end

      it "should not be valid" do
        subject.cpf = "71506250370"
        expect(subject).not_to be_valid
      end
    end
  end
end
