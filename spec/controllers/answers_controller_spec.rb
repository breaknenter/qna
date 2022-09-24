require 'rails_helper'
require Rails.root.join 'spec/controllers/concerns/voted.rb'
require Rails.root.join 'spec/controllers/concerns/commented.rb'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'
  it_behaves_like 'commented'

  let(:author)    { create(:user) }
  let!(:question) { create(:question, author: author) }
  let!(:answer)   { create(:answer, question: question, author: author) }
  let(:user)      { create(:user) }
  let!(:answer2)  { create(:answer, question: question, author: user) }

  describe 'POST #create for authenticated user' do
    before { login(author) }

    let(:valid_answer) do
      post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
    end

    let(:invalid_answer) do
      post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
    end

    context 'with valid attributes' do
      it 'save new @answer in db' do
        expect { valid_answer }.to change(Answer, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'not saved @answer in db' do
        expect { invalid_answer }.to_not change(Answer, :count)
      end
    end
  end

  describe 'POST #create for unauthenticated user' do
    let(:answer) do
      post :create, params: { question_id: question, answer: attributes_for(:answer) }
    end

    it 'save new @answer in db' do
      expect { answer }.to_not change(Answer, :count)
    end
  end

  describe 'DELETE #destroy answer' do
      before { login(author) }

      context 'author' do
        it 'delete answer' do
          expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }
            .to change(Answer, :count).by(-1)
        end

        it 'redirect to questions#show' do
          delete :destroy, params: { question_id: question, id: answer }, format: :js

          expect(response).to render_template :destroy
        end
      end

      context 'not author' do
        before { login(user) }

        it 'delete question' do
          expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }
            .to_not change(Answer, :count)
        end

        it 'redirect to root path' do
          delete :destroy, params: { question_id: question, id: answer }, format: :js

          expect(response).to redirect_to root_path
        end
      end
  end

  describe 'PATCH #update answer' do
    before { login(author) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { text: 'Edited text' } }, format: :js

        answer.reload

        expect(answer.text).to eq 'Edited text'
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: { text: 'Edited text' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not changes answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :text)
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'try to edit other user answer' do
      let(:user2) { create(:user) }

      before { login(user2) }

      it 'not change attributes' do
        patch :update, params: { id: answer, answer: { text: 'Edited text' } }, format: :js

        answer.reload

        expect(question).to_not have_attributes(text: 'Edited text')
      end
    end
  end

  describe 'POST #best' do
    before { login(author) }

    it 'author of question set best answer' do
      post :best, params: { id: answer2 }, format: :js

      question.reload

      expect(answer2).to be_best
      expect(response).to render_template :best
    end

    context 'no author try to set best answer' do
      before { login(user) }

      it 'no author try to set best answer' do
        post :best, params: { id: answer }, format: :js

        question.reload

        expect(answer).to_not be_best
        expect(response).to redirect_to root_path
      end
    end
  end
end
