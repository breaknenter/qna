require 'rails_helper'

shared_examples_for 'voted' do
  let(:author) { create(:author) }
  let(:user)   { create(:user) }

  case described_class.to_s
  when 'QuestionsController'
    let(:voteable) { create(:question, author: author) }
  when 'AnswersController'
    let(:question) { create(:question, author: author) }
    let(:voteable) { create(:answer, question: question, author: author) }
  else
    # show error
  end

  describe 'POST #vote_up' do
    context 'authenticated user vote up' do
      before { login(user) }

      let(:vote) do
        post :vote_up, params: { id: voteable, value: 1 }, format: :json
      end

      it 'changes votes count' do
        expect { vote }.to change(voteable.votes, :count).by(1)
      end

      it 'returns a 200 OK status' do
        vote
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
