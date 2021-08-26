require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    # Создаём массив из 4 объектов Question
    let(:questions) { create_list(:question, 4, author: user) }

    before { get :index }

    it 'fill an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question, author: user) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    let(:valid) do
      post :create, params: { question: attributes_for(:question) }
    end

    let(:invalid) do
      post :create, params: { question: attributes_for(:question, :invalid) }
    end

    context 'with valid attributes' do
      it 'save new @question in db' do
        expect { valid }.to change(Question, :count).by(1)
      end

      it 'redirect to @question (show view)' do
        valid

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

  describe 'DELETE #destroy' do
    let(:author)    { create(:user) }
    let!(:question) { create(:question, author: author) }

    before { login(author) }

    context 'author' do
      it 'delete question' do
        expect { delete :destroy, params: { id: question } }
          .to change(Question, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'not author' do
      before { login(user) }

      it 'delete question' do
        expect { delete :destroy, params: { id: question } }
          .to_not change(Question, :count)
      end

      it 'redirect to questions#show' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to question
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question, author: user) }

    before { login(user) }

    context 'with valid attributes' do
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'Edited title', text: 'Edited text' } }, format: :js

        question.reload

        expect(question).to have_attributes(title: 'Edited title', text: 'Edited text')
      end

      it 'render update view' do
        patch :update, params: { id: question, question: { title: 'Edited title', text: 'Edited text' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not changes question attributes' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end.to_not change(question, :title)
      end

      it 'render update view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'try to edit other user question' do
      let(:user2) { create(:user) }

      before { login(user2) }

      it 'not change' do
        patch :update, params: { id: question, question: { title: 'Edited title', text: 'Edited text' } }, format: :js

        question.reload

        expect(question).to_not have_attributes(title: 'Edited title', text: 'Edited text')
      end
    end
  end
end
