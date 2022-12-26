require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    let(:params) { { search_query: 'Query string', search_by: 'all' } }

    before do
      expect(SearchService).to receive(:call).with(params)

      get :index, params: params
    end

    it 'returns 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'render show' do
      expect(response).to render_template :index
    end
  end
end
