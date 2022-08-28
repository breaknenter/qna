require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it do
      should have_many(:questions)
        .class_name('Question')
        .with_foreign_key('author_id')
    end

    it do
      should have_many(:answers)
        .class_name('Answer')
        .with_foreign_key('author_id')
    end

    it { should have_many(:rewards) }
    it { should have_many(:votes) }
    it do
      should have_many(:comments)
               .class_name('Comment')
               .with_foreign_key('author_id')
    end
    it { should have_many(:authorizations) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '1234') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'github', uid: '1234')

        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let!(:auth) do
          OmniAuth::AuthHash.new(
            provider: 'github',
            uid: '1234',
            info: { email: user.email })
        end

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exists' do
        let!(:auth) do
          OmniAuth::AuthHash.new(
            provider: 'github',
            uid: '1234',
            info: { email: 'not@exists.io' })
        end

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)

          expect(user.email).to eq(auth.info[:email])
        end

        it 'creates authorization' do
          user = User.find_for_oauth(auth)

          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '#author_of?' do
    let!(:author)   { create(:user) }
    let!(:user)     { create(:user) }
    let!(:question) { create(:question, author: author) }

    it { expect(author).to   be_author_of(question) }
    it { expect(user).to_not be_author_of(question) }
  end
end
