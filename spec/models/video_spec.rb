require 'rails_helper'

RSpec.describe Video, type: :model do
  describe "associations" do
    subject(:video) { build_stubbed(:video) }

    specify(:aggregate_failures) do
      expect(video).to belong_to(:user)
    end
  end

  describe "validations" do
    let!(:video){FactoryBot.create :video}
  
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_uniqueness_of(:url) }
  end
end
