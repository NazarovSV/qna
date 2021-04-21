require 'rails_helper'

shared_examples_for 'Voted' do
  let!(:model) { described_class.controller_name.classify.constantize }
  let!(:votable) { create(model.to_s.underscore.to_sym) }

  let!(:user) { create(:user) }
  let!(:authored) { create(model.to_s.underscore.to_sym, user: user) }

  describe 'PATCH #like' do
    context 'user is an author' do
      it 'does not like a resource' do
        login(votable.user)

        expect do
          patch :like, params: { id: votable }, format: :json
        end.to_not change(Vote, :count)
        expect(votable.rating).to eq 0
      end
    end

    context 'user is not an author' do
      before do
        login(user)
      end

      it 'like a resource' do
        expect do
          patch :like, params: { id: votable }, format: :json
        end.to change(Vote, :count).by(1)

        votable.reload

        expect(votable.rating).to eq 1
      end
    end
  end

  describe 'PATCH #dislike' do
    context 'user is an author' do
      it 'does not dislike a resource' do
        login(votable.user)

        expect do
          patch :dislike, params: { id: votable }, format: :json
        end.to_not change(Vote, :count)

        votable.reload

        expect(votable.rating).to eq 0
      end
    end

    context 'user is not an author' do
      before do
        login(user)
      end

      it 'dislike a resource' do
        expect do
          patch :dislike, params: { id: votable }, format: :json
        end.to change(Vote, :count).by(1)

        votable.reload

        expect(votable.rating).to eq -1
      end


      context 'preset like' do
        before do
          create(:vote, :like, user: user, votable: votable)
        end

        it 'dislike a resource' do
          expect do
            patch :dislike, params: { id: votable }, format: :json
          end.to_not change(Vote, :count)

          votable.reload

          expect(votable.rating).to eq -1
        end
      end

      context 'preset dislike' do
        before do
          create(:vote, :dislike, user: user, votable: votable)
        end

        it 'does not dislike a resource' do
          expect do
            patch :dislike, params: { id: votable }, format: :json
          end.to_not change(Vote, :count)

          votable.reload

          expect(votable.rating).to eq 0
        end
      end
    end
  end
end


