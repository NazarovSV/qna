# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do

    context 'sign in as question author' do
      before { login(user) }

      context 'with valid attributes' do
        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }

          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }
        it 'does not change question' do
          old_title = question.title
          old_body = question.body

          question.reload

          expect(question.title).to eq old_title
          expect(question.body).to eq old_body
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'sign in as not question author and try edit' do
      before { login(create(:user)) }

      it 'does not change question' do
        old_title = question.title
        old_body = question.body

        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js

        question.reload

        expect(question.title).to eq old_title
        expect(question.body).to eq old_body
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js

        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    context 'sign in as question author' do
      before { login(question.user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
        expect(flash[:notice]).to match('Your question has been successfully deleted!')
      end
    end

    context 'sign in as not question author' do
      before { login(create(:user)) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(0)
      end

      it 're-renders to question index' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
        expect(flash[:alert]).to match('You do not have permission to delete the question!')
      end

    end
  end
end
