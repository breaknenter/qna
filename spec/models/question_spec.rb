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

    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }

    it { should have_one(:reward).dependent(:destroy) }

    it { should accept_nested_attributes_for :links }
    it { should accept_nested_attributes_for :reward }
  end

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:text) }
  end

  describe '#answers_ex_best' do
    let(:answers) { create_list(:answer, 4, question: question, author: user) }

    before { answers.first.best! }

    it 'get all answers without best' do
      expect(question.answers_ex_best).to match_array(answers.drop(1))
    end
  end
end
