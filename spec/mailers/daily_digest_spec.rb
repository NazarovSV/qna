require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 3) }
    let(:question_ids) { questions.pluck(:id) }
    let(:mail) { DailyDigestMailer.digest(email: user.email, question_ids: question_ids) }

    it "renders the headers" do
      expect(mail.subject).to eq("Question Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("New questions from the last day!")
    end
  end

end
