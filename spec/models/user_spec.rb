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
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe '#author_of?' do
    let!(:author)   { create(:user) }
    let!(:user)     { create(:user) }
    let!(:question) { create(:question, author: author) }

    it { expect(author).to   be_author_of(question) }
    it { expect(user).to_not be_author_of(question) }
  end
end
