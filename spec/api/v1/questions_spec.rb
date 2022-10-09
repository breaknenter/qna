require 'rails_helper'

describe 'Questions API', type: :request do
  let(:author) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: author.id).token }

  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT'       => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 2, question: question, author: question.author) }

      before do
        get api_path,
            params: { access_token: access_token },
            headers: headers
      end

      it_behaves_like 'Status be_successful'

      it_behaves_like 'API List' do
          let(:resource) { json['questions'] }
          let(:list_size) { 2 }
        end

      it_behaves_like 'Returns all public fields' do
        let(:attributes) { %w[id title text created_at updated_at] }
        let(:resource) { question_response }
        let(:object) { question }
      end

      it 'contains author object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'API List' do
          let(:resource) { question_response['answers'] }
          let(:list_size) { 2 }
        end

        it_behaves_like 'Returns all public fields' do
          let(:attributes) { %w[id text created_at updated_at author_id] }
          let(:resource) { answer_response }
          let(:object) { answer }
        end
      end
    end
  end

  context '/api/v1/questions/:question_id' do
    let!(:question) { create(:question, :with_file) }
    let(:question_id) { question.id }
    let!(:comments) { create_list(:comment, 4, commentable: question, author: author) }
    let!(:links) { create_list(:link, 4, linkable: question) }
    let(:question_response) { json['question'] }
    let(:api_path) { "/api/v1/questions/#{question_id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    describe 'GET' do
      before do
        get api_path,
            params: { access_token: access_token },
            headers: headers
      end

      it_behaves_like 'Status be_successful'

      it_behaves_like 'Returns all public fields' do
        let(:attributes) { %w[id title text] }
        let(:resource) { question_response }
        let(:object) { question }
      end

      context 'Links' do
        let(:link) { links.first }
        let(:link_response) { question_response['links'].last }

        it_behaves_like 'API List' do
          let(:resource) { question_response['links'] }
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
          let(:resource) { question_response['files'] }
          let(:list_size) { 1 }
        end
      end

      context 'Comments' do
        let(:comment) { comments.first }
        let(:comment_response) { question_response['comments'].first }

        it_behaves_like 'API List' do
          let(:resource) { question_response['comments'] }
          let(:list_size) { 4 }
        end
      end
    end
  end
end
