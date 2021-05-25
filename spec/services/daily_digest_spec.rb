require 'rails_helper'

RSpec.describe DailyDigest do
  let!(:users) { create_list(:user, 3) }
  let!(:owner) { create(:user) }
  let!(:questions) { create_list(:question, 4, user: owner) }

  subject { DailyDigest.new }

  it 'will look new questions from the last day' do
    expect(Question).to receive(:new_question_from_the_last_day).and_return(Question.all)
    subject.send_digest
  end

  it 'sends daily digest to all users' do
    allow(Question).to receive(:new_question_from_the_last_day).and_return(Question.all)
    allow(User).to receive(:find_each) { |&block| users.each(&block) }
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(email: user.email, question_ids: questions.pluck(:id)).and_call_original }

    subject.send_digest
  end
end
