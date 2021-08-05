require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    # Создаём массив из 4 объектов Question
    let(:questions) { create_list(:question, 4) }

    before { get :index }

    it 'fill an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end
end
