# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentFilesController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question,  :with_attachment_file, user: user) }

  describe 'DELETE #destroy' do
    context 'sign in as question author' do
      before { login(question.user) }

      it 'deletes the question files' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'render delete view' do
        delete :destroy, params: { id: question.files.first }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'sign in as not question author' do
      before { login(create(:user)) }

      it 'try delete file from question' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(0)
      end

      it 'render delete view' do
        delete :destroy, params: { id: question.files.first }, format: :js

        expect(response).to render_template :destroy
      end

    end
  end


end
