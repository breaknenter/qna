require 'rails_helper'

RSpec.describe EmailController, type: :controller do
  describe 'GET #new' do
    before { get :new }

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let!(:user) { create(:user, email: 'joeshmoe@mail.to') }
    let(:exist_email) { post :create, params: { email: 'joeshmoe@mail.to' } }
    let(:not_exist_email) { post :create, params: { email: 'notexist@mail.to' } }

    context 'with exist email' do
      it 'sign in and redirect to root_path' do
        expect(exist_email).to redirect_to(root_path)
      end
    end

    context 'with not exist email' do
      it 'create new user and send confirmation instructions' do
        expect{ not_exist_email }.to change(User, :count).by(1)
      end
    end
  end
end
