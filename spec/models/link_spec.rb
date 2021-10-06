require 'rails_helper'

RSpec.describe Link, type: :model do
    describe 'associations' do
      it { should belong_to :question }
    end

    describe 'validations' do
      it { should validate_presence_of :name }
      it { should validate_presence_of :url }

      it { should     allow_value('https://onepagelove.com').for(:url) }
      it { should_not allow_value('onepagelove.com')
                        .for(:url)
                        .with_message('Invalid URL format') }
    end
end
