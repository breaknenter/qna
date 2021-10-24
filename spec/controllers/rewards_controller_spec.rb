require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let!(:user)   { create(:user) }
  let!(:reward) { create(:reward, user: user) }

  describe 'GET #index' do
    before { login(user) }
    before { get :index }

    it 'get reward' do
      expect(assigns(:rewards)).to include(reward)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end
end
