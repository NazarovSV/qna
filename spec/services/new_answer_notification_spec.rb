require 'rails_helper'

RSpec.describe NewAnswerNotification do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  subject { NewAnswerNotification.new }

  it 'send notification question author' do
    expect(NewAnswerNotificationMailer).to receive(:notify).with(email: user.email, question: question).and_call_original
    subject.call(question)
  end
end
