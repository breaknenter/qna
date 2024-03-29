require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it do
      should have_many(:questions)
        .class_name('Question')
        .with_foreign_key('author_id')
    end

    it do
      should have_many(:answers)
        .class_name('Answer')
        .with_foreign_key('author_id')
    end

    it { should have_many(:rewards) }
    it { should have_many(:votes) }
    it do
      should have_many(:comments)
               .class_name('Comment')
               .with_foreign_key('author_id')
    end
    it { should have_many(:authorizations) }
    it { should have_many(:subscriptions).with_foreign_key('subscriber_id').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_inclusion_of(:admin).in_array([true, false]) }
  end

  describe '#admin!' do
    let!(:user) { create(:user) }
    before { user.admin! }

    it { expect(user).to be_admin }
  end

  describe '#author_of?' do
    let!(:author)   { create(:user) }
    let!(:user)     { create(:user) }
    let!(:question) { create(:question, author: author) }

    it { expect(author).to   be_author_of(question) }
    it { expect(user).to_not be_author_of(question) }
  end
end
