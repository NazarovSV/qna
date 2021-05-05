require 'rails_helper'

shared_examples_for 'Commented' do
  let!(:model) { described_class.controller_name.classify.constantize }
  let!(:commentable) { create(model.to_s.underscore.to_sym) }

  let(:user) { create(:user) }
  let(:second_user) { create(:user) }

  describe 'POST #comment' do
    context 'user is a guest' do
      before do
        logout(commentable.user)
      end

      it 'cant comment resource' do
        expect do
          post :comment, params: { id: commentable, body: 'new body' }, format: :js
        end.to_not change(Comment, :count)
      end
    end

    context 'user is an author' do
      before do
        login(commentable.user)
      end

      it 'comment resource' do
        expect do
          post :comment, params: { id: commentable, body: 'text' }, format: :js
        end.to change(Comment, :count).by(1)
      end

      it 'renders comment view' do
        post :comment, params: { id: commentable, body: 'text' }, format: :js
        expect(response).to render_template 'comments/create'
      end

      it 'not save comment for resource' do
        expect do
          post :comment, params: { id: commentable, body: nil }, format: :js
        end.to change(Comment, :count).by(0)
      end
    end

    context 'user is not an author' do
      before do
        login(second_user)
      end

      it 'comment resource' do
        expect do
          post :comment, params: { id: commentable, body: 'new body' }, format: :js
        end.to change(Comment, :count).by(1)
      end

      it 'renders comment view' do
        post :comment, params: { id: commentable, body: 'text' }, format: :js
        expect(response).to render_template 'comments/create'
      end

      it 'not save comment for resource' do
        expect do
          post :comment, params: { id: commentable, body: nil }, format: :js
        end.to change(Comment, :count).by(0)
      end
    end
  end
end
