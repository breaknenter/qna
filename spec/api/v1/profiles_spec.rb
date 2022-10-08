require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT'       => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id).token }

      before do
        get api_path,
            params: { access_token: access_token },
            headers: headers
      end

      it_behaves_like 'Status be_successful'

      it_behaves_like 'Returns all public fields' do
        let(:resource) { json['user'] }
        let(:user) { me }
      end

      it_behaves_like 'Does not return private fields'
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:users) { create_list(:user, 4) }
      let(:me) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id).token }

      before do
        get api_path,
            params: { access_token: access_token },
            headers: headers
      end

      it_behaves_like 'Status be_successful'

      it 'list of users does not include me' do
        ids = json['users'].pluck('id')

        expect(ids).to_not include(me.id)
      end

      it 'returns list of users ex me' do
        expect(json['users'].size).to eq 3
      end

      it_behaves_like 'Returns all public fields' do
        let(:resource) { json['users'].last }
        let(:user) { users.last }
      end

      it_behaves_like 'Does not return private fields'
    end
  end
end
