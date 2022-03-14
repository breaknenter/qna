require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    subject { build(:vote) }

    it { should belong_to(:user) }
    it { should belong_to(:voteable) }
  end

  describe 'validations' do
    subject { build(:vote) }

    it { should validate_presence_of(:value) }
    it { should validate_inclusion_of(:value).in_array([1, -1]) }
    it do
      should validate_uniqueness_of(:user)
               .scoped_to(:voteable_type, :voteable_id)
               .with_message('you have already voted')
    end
  end

  describe 'validates :voteable_type' do
    subject { build(:vote, voteable_type: 'Other') }
    it 'invalid voteable_type' do
      subject.valid?

      expect(subject.errors[:voteable_type]).to include('is not included in the list')
    end
  end

  describe 'validate :self_like' do
    let!(:question) { create :question }
    let!(:vote) { build(:vote, user: question.author, voteable: question) }

    it "drop self-like with error 'self-like it for xxxx'" do
      vote.valid?

      expect(vote.errors[:user]).to include('self-like it for xxxx')
    end
  end
end
