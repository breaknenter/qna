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

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:create) do
      post :create, params: { question: attributes_for(:question) }
    end

    let(:invalid) do
      post :create, params: { question: attributes_for(:question, :invalid) }
    end

    context 'with valid attributes' do
      it 'save new @question in db' do
        expect { create }.to change(Question, :count).by(1)
      end

      it 'redirect to @question (show view)' do
        create

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { invalid }.to_not change(Question, :count)
      end

      it 'render new view' do
        invalid

        expect(response).to render_template :new
      end
    end
  end
end