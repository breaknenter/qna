require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT'       => 'application/json' }
  end

  let!(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id).token }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, :with_file, question: question, author: user) }
  let(:answer_id) { answer.id }

  describe '/api/v1/answers/:answer_id/' do
    let(:api_path) { "/api/v1/answers/#{answer_id}" }
    let(:answer_response) { json['answer'] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    describe 'GET' do
      let!(:comments) { create_list(:comment, 4, commentable: answer, author: user) }
      let!(:links) { create_list(:link, 4, linkable: answer) }

      before do
        get api_path,
            params: { access_token: access_token },
            headers: headers
      end

      it_behaves_like 'Status be_successful'

      it_behaves_like 'Returns all public fields' do
        let(:attributes) { %w[id author_id text links created_at updated_at] }
        let(:resource) { answer_response }
        let(:object) { answer }
      end

      context 'Links' do
        let(:link) { links.first }
        let(:link_response) { answer_response['links'].last }

        it_behaves_like 'API List' do
          let(:resource) { answer_response['links'] }
          let(:list_size) { 4 }
        end

        it_behaves_like 'Returns all public fields' do
            let(:attributes) { %w[id name url] }
            let(:resource) { link_response }
            let(:object) { link }
        end
      end

      context 'Files' do
        it_behaves_like 'API List' do
          let(:resource) { answer_response['files'] }
          let(:list_size) { 1 }
        end
      end

      context 'Comments' do
        let(:comment) { comments.first }
        let(:comment_response) { answer_response['comments'].first }

        it_behaves_like 'API List' do
          let(:resource) { answer_response['comments'] }
          let(:list_size) { 4 }
        end
      end
    end
  end
end
