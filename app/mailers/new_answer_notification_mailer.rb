class NewAnswerNotificationMailer < ApplicationMailer
  def notify(email:, question:)
    @question = question
    mail to: email, subject: "New Answer for question \""#{@question.title}\""
  end
end
