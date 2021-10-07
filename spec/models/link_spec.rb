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

    describe '#gist?' do
      let!(:gist_url) { create(:link, url: 'https://gist.github.com/breaknenter/297fdd1adf66023e67b752ddf96b37d4') }
      let!(:not_gist) { create(:link, url: 'https://onepagelove.com') }

      it { expect(gist_url).to     be_gist }
      it { expect(not_gist).to_not be_gist }
    end
end
