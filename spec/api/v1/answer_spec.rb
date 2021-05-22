require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) {{ "CONTENT_TYPE" => 'application/json',
                   "ACCEPT" => 'application/json' }}

  describe 'GET /api/v1/questions/:id/index' do
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
end