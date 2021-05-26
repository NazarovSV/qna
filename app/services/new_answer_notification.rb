class NewAnswerNotification
  def call(question)
    NewAnswerNotificationMailer.notify(email: question.user.email, question: question).deliver_later
  end
end
