require 'rails_helper'

describe RewardsController, type: :controller, aggregate_failures: true do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let!(:first_question) { create(:question, user: user) }
    let!(:second_question) { create(:question, user: user) }
    let!(:first_reward) { create(:reward, question: first_question, recipient: user) }
    let!(:second_reward) { create(:reward, question: second_question, recipient: user) }

    before do
      login(user)
      get :index
    end

    it 'creates and populates an array of user awards' do
      expect(@controller.rewards).to match_array(user.rewards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end