require 'rails_helper'

shared_examples_for 'commentable' do
  let!(:author) { create(:author) }
  let!(:user)   { create(:user) }

  case described_class.to_s
  when 'Question'
    let!(:commentable) { create(:question, author: author) }
  when 'Answer'
    let!(:question)    { create(:question, author: author) }
    let!(:commentable) { create(:answer, question: question, author: author) }
  else
    # show error
  end
end
