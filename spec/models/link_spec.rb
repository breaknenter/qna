require 'rails_helper'

RSpec.describe Link, type: :model do
    describe 'associations' do
      it { belong_to(:question) }
    end

    describe 'validations' do
      it { validate_presence_of(:name) }
      it { validate_presence_of(:url) }
    end
end
