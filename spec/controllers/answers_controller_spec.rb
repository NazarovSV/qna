# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:answer), question_id: question }
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        end.to_not change(Answer, :count)
      end

      it 'render question view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question) }

    context 'sign in as answers author' do
      before { login(answer.user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to question_path(question)
        expect(flash[:notice]).to match('Your answer has been successfully deleted!')
      end

    end

    context 'sign in as not answers author' do
      before { login(create(:user)) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(0)
      end

      it 're-renders question show' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to question_path(question)
        expect(flash[:alert]).to match('You do not have permission to delete the answer!')
      end

    end
  end
end
