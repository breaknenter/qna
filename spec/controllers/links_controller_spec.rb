require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:author)   { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:user)     { create(:user) }

  before do
    question.links.create(name: 'Link', url: 'https://link.to')
  end

  describe 'DELETE #destroy' do
    let(:delete_link) do
        delete :destroy, params: { id: question.links.first }, format: :js
    end

    context 'author' do
      before { login(author) }

      it 'delete link' do
        expect { delete_link }.to change(question.links, :count).by(-1)
      end

      it 'render :destroy' do
        delete_link

        expect(response).to render_template :destroy
      end
    end

    context 'not author' do
      before { login(user) }

      it 'not delete link' do
        expect { delete_link }.to_not change(question.links, :count)
      end

      it 'redirect to root url' do
        expect(delete_link).to redirect_to root_url
      end
    end

    context 'user is guest' do
      it 'not delete link' do
        expect { delete_link }.to_not change(question.links, :count)
      end

      it '401: unauthorized' do
        delete_link

        expect(response.status).to eq 401
      end
    end
  end
end
