require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:user) }

  it 'should find question subscription by user' do
    question = create(:question)
    user = create(:user)
    subscription = create(:subscription, user: user, question: question)

    expect(Subscription.by_question_and_user(user: user, question: question)).to eq subscription
  end
end
