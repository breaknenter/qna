require 'rails_helper'

RSpec.describe FilesController, type: :controller do

  let!(:author)   { create(:user) }
  let!(:user)     { create(:user) }
  let!(:question) { create(:question, :with_file, author: author) }

  let(:delete_file) do
    delete :destroy, params: { id: question.files.first }, format: :js
  end

  describe 'DELETE #destroy' do
    context 'user is author' do
      before { login(author) }

      it 'delete file' do
        expect { delete_file }.to change(question.files, :count).by(-1)
      end

      it 'render :destroy' do
        delete_file

        expect(response).to render_template :destroy
      end
    end

    context 'user is not author' do
      before { login(user) }

      it 'not delete file' do
        expect { delete_file }.to_not change(question.files, :count)
      end

      it 'redirect to root url' do
        expect(delete_file).to have_http_status(:forbidden)
      end
    end

    context 'user is guest' do
      it 'not delete file' do
        expect { delete_file }.to_not change(question.files, :count)
      end

      it '401: unauthorized' do
        delete_file

        expect(response.status).to eq 401
      end
    end
  end

end
