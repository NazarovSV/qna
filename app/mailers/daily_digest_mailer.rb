class DailyDigestMailer < ApplicationMailer

  def digest(email:, question_ids:)
    @questions = Question.where(id: question_ids)
    mail to: email, subject: 'Question Digest'
  end
end
