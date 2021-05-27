class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question

  def self.by_question_and_user(user:, question:)
    find_by(user: user, question: question)
  end
end
