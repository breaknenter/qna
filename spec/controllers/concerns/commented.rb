require 'rails_helper'

shared_examples_for 'commented' do
  let(:author) { create(:author) }
  let(:user)   { create(:user) }

  case described_class.to_s
  when 'QuestionsController'
    let(:commentable) { create(:question, author: author) }
  when 'AnswersController'
    let(:question)    { create(:question, author: author) }
    let(:commentable) { create(:answer, question: question, author: author) }
  else
    # show error
  end

  describe 'POST #create_comment' do
    context 'authenticated user add comment' do
      before { login(user) }

      let(:comment) do
        post :create_comment, params: { id: commentable, comment: { text: 'Comment text'} }, format: :json
      end

      it 'changes comments count' do
        expect { comment }.to change(commentable.comments, :count).from(0).to(1)
      end
    end
  end
end
