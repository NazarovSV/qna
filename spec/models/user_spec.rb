# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:questions).dependent(:destroy) }
  it { is_expected.to have_many(:authorizations).dependent(:destroy) }

  describe "checking the question's author" do
    let(:question) { create(:question) }

    it 'current user is the author of the question' do
      user = question.user
      expect(user).to be_author(question)
    end

    it 'current user is not the author of the question' do
      user = create(:user)
      expect(user).to_not be_author(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email }) }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)

      User.find_for_oauth(auth)
    end
  end

  describe '.create_with_oauth' do
    context 'valid params' do
      it 'create a new user' do
        expect{User.save_with_oauth(email: 'test@example.com', uid: '123', provider: 'provider')}.to change(User, :count).by(1)
      end

      it 'create a new users authorization' do
        expect{ User.save_with_oauth(email: 'test@example.com', uid: '123', provider: 'provider') }.to change(Authorization, :count).by(1)
      end

    end

    context 'invalid params' do
      describe 'invalid email' do
        it 'user is not created' do
          expect{User.save_with_oauth(email: nil, uid: '123', provider: 'provider')}.to change(User, :count).by(0)
        end

        it 'user authorization is not created' do
          expect{ User.save_with_oauth(email: nil, uid: '123', provider: 'provider') }.to change(Authorization, :count).by(0)
        end
      end

      describe 'invalid uid & provider' do
        it 'user is not created' do
          expect{User.save_with_oauth(email: nil, uid: '123', provider: 'provider')}.to change(User, :count).by(0)
        end

        it 'user authorization  is not created' do
          expect{ User.save_with_oauth(email: nil, uid: '123', provider: 'provider') }.to change(Authorization, :count).by(0)
        end
      end
    end

  end
end
