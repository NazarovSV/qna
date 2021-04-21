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
          post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        end.to_not change(Answer, :count)
      end

      it 'render question view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js  }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question) }

    context 'sign in as answers author' do
      before { login(answer.user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to render_template :destroy
        expect(flash[:notice]).to match('Your answer has been successfully deleted!')
      end

    end

    context 'sign in as not answers author' do
      before { login(create(:user)) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js  }.to change(Answer, :count).by(0)
      end

      it 'renders destroy show' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to render_template :destroy
        expect(flash[:alert]).to match('You do not have permission to delete the answer!')
      end

    end
  end

  describe 'PATCH #update' do
    context 'sign in as answers author' do
      before { login(answer.user) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: {body: 'New body'} }, format: :js
          answer.reload
          expect(answer.body).to eq 'New body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: {body: 'New body'} }, format: :js
          expect(response).to render_template :update
        end
      end

      context  'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end

      end

    end

    context "trying to change other people's answers" do
      before { login(create(:user)) }

      it 'does not change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js

        answer.reload

        expect(answer.body).to_not eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end

    end

  end

  describe 'PATCH #best_answer' do

      context 'User is author of question' do
        before { login(user) }

        it 'set best answer' do
          patch :best_answer, params: { id: answer, answer: { best: true} }, format: :js
          answer.reload
          expect(answer.question.best_answer).to be
        end

        it 'set another best answer' do
          question = create(:question)
          answers = create_list(:answer, 2, question: question)

          question.update(best_answer: answers.first)

          patch :best_answer, params: { id: answers.second, answer: { best: true} }, format: :js

          question.reload

          expect(question.best_answer).to eq answers.second
        end

        it 'renders best_answer view' do
          patch :best_answer, params: { id: answer, answer: { body: 'new body'}, format: :js }
          expect(response).to render_template :best_answer
        end
      end

      context 'User is not author of question' do
        before { login(user) }

        it 'tries to set best answer' do
          patch :best_answer, params: { id: answer, answer: { best: true} }, format: :js
          answer.reload
          expect(question.best_answer).not_to be
        end
      end

      context 'Unauthorized user' do
        it 'tries to set best answer' do
          patch :best_answer, params: { id: answer, answer: { best: true} }, format: :js
          answer.reload
          expect(question.best_answer).not_to be
        end
      end
    it_behaves_like 'Voted'
  end
end
