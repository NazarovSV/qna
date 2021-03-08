# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:questions).dependent(:destroy) }

  describe "checking the question's author" do
    let (:question) { create(:question) }

    it 'current user is the author of the question' do
      user = question.user
      expect(user).to be_author(entity: question)
    end

    it 'current user is not the author of the question' do
      user = create(:user)
      expect(user).to_not be_author(entity: question)
    end
  end



end
