require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) {{ "CONTENT_TYPE" => 'application/json',
                   "ACCEPT" => 'application/json' }}

  let(:api_path) { '/api/v1/profiles/me' }
  it_behaves_like 'API Authorizable' do
    let(:method) { 'GET' }
  end

  context 'authorized' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    before do
      get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
    end

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'return all public fields' do
      %w[id email admin created_at updated_at].each do |field|
        expect(json[field]).to eq me.send(field).as_json
      end
    end

    it 'does not return private fields' do
      %w[password encrypted_password].each do |field|
        expect(json).to_not have_key(field)
      end
    end
  end
end