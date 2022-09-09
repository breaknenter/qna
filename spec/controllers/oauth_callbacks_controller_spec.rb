require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) do
      OmniAuth::AuthHash.new(
        provider: 'github',
        uid:      '1234',
        info: {
          email: 'test@email.io'
        }
      )
    end

    let(:oauth) { OmniAuth.config.mock_auth[:provider] = oauth_data }

    before { @request.env['omniauth.auth'] = oauth_data }

    context 'if user exists' do
      let(:user) { FindForOauthService.new(oauth).call }

      before do
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'if user does not exists' do
      before do
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'Vkontakte' do
    let(:oauth_data) do
      OmniAuth::AuthHash.new(
        provider: 'vkontakte',
        uid:      '1234',
        info: {
          email: 'test@email.io'
        }
      )
    end

    let(:oauth) { OmniAuth.config.mock_auth[:provider] = oauth_data }

    before { @request.env['omniauth.auth'] = oauth_data }

    context 'if user exists' do
      let(:user) { FindForOauthService.new(oauth).call }

      before do
        get :vkontakte
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'if user does not exists' do
      before do
        get :vkontakte
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
