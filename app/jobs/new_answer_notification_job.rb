class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(question:)
    NewAnswerNotification.new.call(question)
  end
end
