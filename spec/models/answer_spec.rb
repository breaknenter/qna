require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user)     { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'associations' do
    it do
      belong_to(:author)
        .class_name('User')
        .with_foreign_key('author_id')
    end

    it { belong_to(:question) }

    it do
      have_one(:question_with_best_answer)
        .class_name('Question')
        .with_foreign_key('best_answer_id')
        .dependent(:nullify)
    end
  end

  describe 'validations' do
    it { validate_presence_of(:text) }
  end

  describe '#best!' do
    let!(:answer) { create(:answer, question: question, author: user) }

    before { answer.best! }

    it 'set as best' do
      expect(question.best_answer.id).to eq(answer.id)
    end
  end

  describe '#best?' do
    let!(:answer) { create(:answer, question: question, author: user) }

    it 'answer not be best' do
      expect(answer).not_to be_best
    end

    context 'answer set as best' do
      before { answer.best! }

      it { expect(answer).to be_best }
    end
  end
end
