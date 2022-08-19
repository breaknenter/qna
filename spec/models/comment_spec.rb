require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    subject { build(:comment) }

    it do
      should belong_to(:author)
               .class_name('User')
               .with_foreign_key('author_id')
    end
    it { should belong_to(:commentable) }
  end

  describe 'validations' do
    subject { build(:comment) }

    it { should validate_presence_of(:text) }
    it { should validate_length_of(:text).is_at_least(2).is_at_most(256) }
  end

  describe 'validates :commentable_type' do
    subject { build(:comment, commentable_type: 'Other') }
    it 'invalid commentable_type' do
      subject.valid?

      expect(subject.errors[:commentable_type]).to include('is not included in the list')
    end
  end
end
