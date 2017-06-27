require "rails_helper"

RSpec.describe Location, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:place_id) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
  end
end
