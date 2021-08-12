require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create for authenticated user' do
    let(:user) { create(:user) }

    let(:valid_answer) do
      post :create, params: { question_id: question, answer: attributes_for(:answer) }
    end

    let(:invalid_answer) do
      post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
    end

    before { login(user) }

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
end
