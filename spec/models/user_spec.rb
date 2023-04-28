require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    subject(:user) { build_stubbed(:user) }

    specify(:aggregate_failures) do
      expect(user).to have_many(:video)
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:user_name) }
    it { is_expected.to validate_presence_of(:password) }
  end
end
