require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }

    let(:valid_answer) do
      post :create, params: { question_id: question, answer: attributes_for(:answer) }
    end

    let(:invalid_answer) do
      post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
    end

    context 'with valid attributes' do
      it 'save new @answer in db' do
        expect { valid_answer }.to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'not saved @answer in db' do
        expect { invalid_answer }.to_not change(question.answers, :count)
      end
    end
  end
end
