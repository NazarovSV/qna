# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let!(:question_link) { create(:link, linkable: question) }
  let!(:answer_link) { create(:link, linkable: answer) }

  describe 'DELETE #destroy' do
    context 'sign in as question author' do
      before { login(question.user) }

      it 'deletes the question links' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'render delete view' do
        delete :destroy, params: { id: question.links.first }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'sign in as not question author' do
      before { login(create(:user)) }

      it 'try delete links from question' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }.to change(question.links, :count).by(0)
      end

      it 'redirect to root path' do
        delete :destroy, params: { id: question.links.first }, format: :js

        expect(response).to redirect_to root_path
      end

    end

    context 'sign in as answer author' do
      before { login(question.user) }

      it 'deletes the answer links' do
        expect { delete :destroy, params: { id: answer.links.first }, format: :js }.to change(answer.links, :count).by(-1)
      end

      it 'render delete view' do
        delete :destroy, params: { id: answer.links.first }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'sign in as not answer author' do
      before { login(create(:user)) }

      it 'try delete links from question' do
        expect { delete :destroy, params: { id: answer.links.first }, format: :js }.to change(answer.links, :count).by(0)
      end

      it 'redirect to root path' do
        delete :destroy, params: { id: answer.links.first }, format: :js

        expect(response).to redirect_to root_path
      end

    end
  end


end
