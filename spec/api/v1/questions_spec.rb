require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{ "CONTENT_TYPE" => 'application/json',
                   "ACCEPT" => 'application/json' }}

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before do
        get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |field|
          expect(json['questions'].first[field]).to eq questions.first.send(field).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user_id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |field|
            expect(answer_response[field]).to eq answer.send(field).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question, :with_attached_files) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let!(:comments) { create_list(:comment, 3, commentable: question, user: create(:user)) }
    let!(:links) { create_list(:link, 3, linkable: question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return all public fields' do
        %w[id title body created_at updated_at].each do |field|
          expect(question_response[field]).to eq question.send(field).as_json
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { question_response['comments'].first }

        it 'returns list of answers' do
          expect(question_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |field|
            expect(comment_response[field]).to eq comment.send(field).as_json
          end
        end

        it 'does not return private fields' do
          %w[commentable_id, commentable_type].each do |field|
            expect(comment_response).to_not have_key(field)
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_response) { question_response['links'].first }

        it 'returns list of links' do
          expect(question_response['links'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |field|
            expect(link_response[field]).to eq link.send(field).as_json
          end
        end
      end

      describe 'attached files' do
        let(:file) { question.files.first }
        let(:file_url) { question_response['files'].first }

        it 'returns list of links' do
          expect(question_response['files'].size).to eq 2
        end

        it 'return url' do
          expect(file_url).to eq rails_blob_url(file, only_path: true )
        end
      end
    end
  end
end