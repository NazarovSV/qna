require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) {{ "CONTENT_TYPE" => 'application/json',
                   "ACCEPT" => 'application/json' }}

  describe 'GET /api/v1/questions/:id/answers' do
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let!(:answer) { answers.first }
    let!(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |field|
          expect(json['answers'].first[field]).to eq answer.send(field).as_json
        end
      end

      it 'does not return private fields' do
        expect(json).to_not have_key('question_id')
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:question) { create(:question) }
    let(:access_token) { create(:access_token) }
    let!(:answer) { create(:answer, :with_attached_files, question: question) }
    let!(:api_path) { "/api/v1/answers/#{answer.id}" }
    let!(:comments) { create_list(:comment, 3, commentable: answer, user: create(:user)) }
    let!(:links) { create_list(:link, 3, linkable: answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorize' do
      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |field|
          expect(json['answer'][field]).to eq answer.send(field).as_json
        end
      end

      describe 'question' do
        let!(:answer_response) { json['answer'] }

        it 'returns question' do
          expect(answer_response['question']).to be
        end

        it 'returns all public fields' do
          %w[id title body created_at updated_at].each do |field|
            expect(answer_response['question'][field]).to eq question.send(field).as_json
          end
        end
      end

      it_behaves_like 'API Commentable' do
        let(:comment) { comments.first }
        let(:comments_response) { json['answer']['comments'] }
        let(:comment_response) { comments_response.first }
      end

      it_behaves_like 'API Linkable' do
        let(:link) { links.first }
        let(:links_response) { json['answer']['links'] }
        let(:link_response) { links_response.first }
      end

      it_behaves_like 'API Attacheble' do
        let(:file) { answer.files.first }
        let(:files_response) { json['answer']['files'] }
        let(:file_response) { files_response.first }
        let(:files) { answer.files }
      end
    end
  end
end