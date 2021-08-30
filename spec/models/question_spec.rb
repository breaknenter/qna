require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user)     { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'associations' do
    it do
      belong_to(:author)
        .class_name('User')
        .with_foreign_key('author_id')
    end

    it do
      belong_to(:best_answer)
        .class_name('Answer')
        .with_foreign_key('best_answer_id')
        .dependent(:destroy)
        .optional
    end

    it { have_many(:answers).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:text) }
  end

  describe '#set_best_answer' do
    let(:answer) { create(:answer, question: question, author: user) }

    before { question.set_best_answer(answer) }

    it 'best answer set' do
      expect(question.best_answer.id).to eq(answer.id)
    end
  end

  describe '#answers_ex_best' do
    let(:answers) { create_list(:answer, 4, question: question, author: user) }

    before { question.set_best_answer(answers.first) }

    it 'get all answers without best' do
      expect(question.answers_ex_best).to match_array(answers.drop(1))
    end
  end
end
