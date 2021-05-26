require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:service) { double('NewAnswerNotification') }
  let(:question) { create(:question) }

  before do
    allow(NewAnswerNotification).to receive(:new).and_return(service)
  end

  it 'calls Notification#call' do
    expect(service).to receive(:call).with(question)
    NewAnswerNotificationJob.perform_now(question: question)
  end
end
