require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:author)   { create(:user) }
  let(:user)     { create(:user) }
  let!(:question) { create(:question, author: author) }
  let!(:answer)   { create(:answer, question: question, author: author) }

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

        it 'redirect to questions#show' do
          delete :destroy, params: { question_id: question, id: answer }, format: :js

          expect(response).to render_template :destroy
        end
      end
    end
end
