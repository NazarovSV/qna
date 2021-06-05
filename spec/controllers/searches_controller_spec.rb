require 'rails_helper'

describe SearchesController, type: :controller, aggregate_failures: true do

  describe 'GET #index' do
    context 'with valid attributes' do
      context 'question' do
        let!(:questions) { create_list(:question, 4) }

        before do
          expect(Search).to receive(:call).and_return(questions)
          get :index, params: { request: questions.first.title, type: 'question' }
        end

        it "renders index view" do
          expect(response).to render_template :index
        end

        it "200" do
          expect(response).to be_successful
        end

        it "assign Search.call to @result" do
          expect(assigns(:result)).to eq questions
        end
      end

      context 'answer' do
        let!(:answers) { create_list(:answer, 4) }

        before do
          expect(Search).to receive(:call).and_return(answers)
          get :index, params: { request: answers.first.body, type: 'answer' }
        end

        it "renders index view" do
          expect(response).to render_template :index
        end

        it "200" do
          expect(response).to be_successful
        end

        it "assign Search.call to @result" do
          expect(assigns(:result)).to eq answers
        end
      end

      context 'comment' do
        let!(:comments) { create_list(:comment, 4, commentable: create(:question)) }

        before do
          expect(Search).to receive(:call).and_return(comments)
          get :index, params: { request: comments.first.body, type: 'comment' }
        end

        it "renders index view" do
          expect(response).to render_template :index
        end

        it "200" do
          expect(response).to be_successful
        end

        it "assign Search.call to @result" do
          expect(assigns(:result)).to eq comments
        end
      end

      context 'user' do
        let!(:users) { create_list(:user, 4) }

        before do
          expect(Search).to receive(:call).and_return(users)
          get :index, params: { request: users.first.email, type: 'user' }
        end

        it "renders index view" do
          expect(response).to render_template :index
        end

        it "200" do
          expect(response).to be_successful
        end

        it "assign Search.call to @result" do
          expect(assigns(:result)).to eq users
        end
      end
    end

    context 'with invalid attributes' do
      before do
        get :index, params: { request: nil, type: nil }
      end

      it "renders index view" do
        expect(response).to redirect_to :root
      end
    end
  end
end