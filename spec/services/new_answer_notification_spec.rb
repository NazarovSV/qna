require 'rails_helper'

RSpec.describe NewAnswerNotification do
  let!(:users) { create_list(:user, 4) }
  let!(:question) { create(:question, user: users.first) }
  let!(:subscription_first) { create(:subscription, user: users.second, question: question)}
  let!(:subscription_second) { create(:subscription, user: users.third, question: question)}
  let!(:subscribers) { [question.user, subscription_first.user, subscription_second.user] }

  subject { NewAnswerNotification.new }

  it 'send notification to subscribers' do
    allow(User).to receive(:find_each){ |&block| subscribers.each(&block) }
    subscribers.each { |subscriber| expect(NewAnswerNotificationMailer).to receive(:notify).with(email: subscriber.email, question: question).and_call_original }
    subject.call(question)
  end
end
