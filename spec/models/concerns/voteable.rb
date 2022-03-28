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
end
