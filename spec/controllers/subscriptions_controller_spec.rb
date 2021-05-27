require 'rails_helper'

describe SubscriptionsController, type: :controller, aggregate_failures: true do
  context 'Authenticated user' do
    describe 'POST #create' do
      let!(:user) { create(:user) }
      let!(:question) { create(:question) }

      before { login(user) }

      it 'create new subscription' do
        expect do
          post :create, params: { question_id: question.id, format: :js }
        end.to change(Subscription, :count).by(1)
      end

      it 'render create view' do
        post :create, params: { question_id: question.id, format: :js }
        expect(response).to render_template :create
      end
    end

    describe 'DELETE #destroy' do
      let!(:user) { create(:user) }
      let!(:question) { create(:question) }
      let!(:subscription) { create(:subscription, user: user, question: question) }

      before { login(user) }

      it 'destroy subscription' do
        expect do
          delete :destroy, params: { id: subscription.id, format: :js }
        end.to change(Subscription, :count).by(-1)
      end

      it 'render create view' do
        delete :destroy, params: { id: subscription.id, format: :js }
        expect(response).to render_template :destroy
      end
    end

  end

  context "Unauthenticated user" do

    describe 'POST #create' do
      let!(:user) { create(:user) }
      let!(:question) { create(:question) }

      it 'create new subscription' do
        expect do
          post :create, params: { question_id: question.id, format: :js }
        end.to change(Subscription, :count).by(0)
      end

      it '401' do
        post :create, params: { question_id: question.id, format: :js }
        is_expected.to respond_with 401
      end
    end

    describe 'DELETE #destroy' do
      let!(:user) { create(:user) }
      let!(:question) { create(:question) }
      let!(:subscription) { create(:subscription, user: user, question: question) }

      it 'destroy subscription' do
        expect do
          delete :destroy, params: { id: subscription.id, format: :js }
        end.to change(Subscription, :count).by(0)
      end

      it '403' do
        delete :destroy, params: { id: subscription.id, format: :js }
        is_expected.to respond_with 401
      end
    end

  end
end
