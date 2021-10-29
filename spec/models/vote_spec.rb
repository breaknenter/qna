require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:votable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:value) }
    it { should validate_inclusion_of(:value).in_array([1, -1]) }
  end

  describe 'validates :user, uniqueness' do
    let!(:vote) { create :vote }
    let!(:revote) { build :vote, user: vote.user, votable: vote.votable }

    it "re-voting will throw an error 'you have already voted'" do
      revote.valid?

      expect(revote.errors[:user]).to include('you have already voted')
    end
  end
end
