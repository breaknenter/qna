require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { build(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user)       { create(:user) }
    let(:other_user) { build(:user) }

    let(:user_question)  { build(:question, author: user) }
    let(:other_question) { build(:question, author: other_user) }

    let(:user_answer)  { build(:answer, question: user_question, author: user) }
    let(:other_answer) { build(:answer, question: other_question, author: other_user) }

    let(:user_link)  { build(:link, linkable: user_question) }
    let(:other_link) { build(:link, linkable: other_question) }

    let(:user_question_attachment) do
      create(:question, :with_file, author: user).files.first
    end

    let(:other_question_attachment) do
      create(:question, :with_file, author: other_user).files.first
    end

    let(:user_answer_attachment) do
      create(:answer, :with_file, question: user_question, author: user).files.first
    end

    let(:other_answer_attachment) do
      create(:answer, :with_file, question: other_question, author: other_user).files.first
    end

    context 'for all' do
      it { should     be_able_to :read,   :all }
      it { should_not be_able_to :manage, :all }
    end

    context 'Question' do
      context '#create' do
        it { should be_able_to :create, Question }
      end

      context '#update' do
        it { should     be_able_to :update, user_question }
        it { should_not be_able_to :update, other_question }
      end

      context '#destroy' do
        it { should     be_able_to :destroy, user_question }
        it { should_not be_able_to :destroy, other_question }
      end

      context '#answers' do
        it { should be_able_to :answers, user_question }
      end

      context '#vote_up' do
        it { should     be_able_to :vote_up, other_question }
        it { should_not be_able_to :vote_up, user_question }
      end

      context '#vote_down' do
        it { should     be_able_to :vote_down, other_question }
        it { should_not be_able_to :vote_down, user_question }
      end
    end

    context 'Answer' do
      context '#create' do
        it { should be_able_to :create, Answer }
      end

      context '#update' do
        it { should     be_able_to :update, user_answer }
        it { should_not be_able_to :update, other_answer }
      end

      context '#destroy' do
        it { should     be_able_to :destroy, user_answer }
        it { should_not be_able_to :destroy, other_answer }
      end

      context '#vote_up' do
        it { should     be_able_to :vote_up, other_answer }
        it { should_not be_able_to :vote_up, user_answer }
      end

      context '#vote_down' do
        it { should     be_able_to :vote_down, other_answer }
        it { should_not be_able_to :vote_down, user_answer }
      end

      context '#best!' do
        it { should     be_able_to :best, user_answer }
        it { should_not be_able_to :best, other_answer }
      end
    end

    context 'Link' do
      context '#destroy' do
        it { should     be_able_to :destroy, user_link }
        it { should_not be_able_to :destroy, other_link }
      end
    end

    context 'Attachment' do
      context '#destroy for question' do
        it { should     be_able_to :destroy, user_question_attachment }
        it { should_not be_able_to :destroy, other_question_attachment }
      end

      context '#destroy for answer' do
        it { should     be_able_to :destroy, user_answer_attachment }
        it { should_not be_able_to :destroy, other_answer_attachment }
      end
    end

    context 'Comment' do
      context '#create' do
        it { should be_able_to :create, Comment }
      end

      context '#create_comment for question' do
        it { should be_able_to :create_comment, Question }
      end

      context '#create_comment for answer' do
        it { should be_able_to :create_comment, Answer }
      end
    end

    context 'User' do
      context '#index' do
        it { should be_able_to :index, user }
      end

      context '#me' do
        it { should be_able_to :me, user }
      end
    end
  end
end
