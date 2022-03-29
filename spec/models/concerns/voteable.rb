require 'rails_helper'

shared_examples_for 'voteable' do
  let!(:author) { create(:author) }
  let!(:user)   { create(:user) }

  case described_class.to_s
  when 'Question'
    let!(:voteable) { create(:question, author: author) }
  when 'Answer'
    let!(:question) { create(:question, author: author) }
    let!(:voteable) { create(:answer, question: question, author: author) }
  else
    # show error
  end

  describe '#vote!' do
    it 'user vote up' do
      expect { voteable.vote!(user: user, value: 1) }.to change(voteable.votes, :count).from(0).to(1)
    end
  end

  describe '#rating' do
    let!(:users) { create_list(:user, 7) }
    votes = [1, 1, 1, 1, -1, 1, 1]

    before do
      users.each_with_index do |user, num|
        voteable.vote!(user: user, value: votes[num])
      end
    end

    it 'rating must equal 5' do
      expect(voteable.rating).to eq(5)
    end
  end
end
