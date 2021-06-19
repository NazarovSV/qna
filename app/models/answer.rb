# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  scope :without_best, lambda {
                         joins(:question).where('questions.best_answer_id IS NULL OR questions.best_answer_id != answers.id')
                       }

  scope :best, -> { joins(:question).where('questions.best_answer_id = answers.id') }

  after_create :new_answer_notify

  validates :body, presence: true

  def best_answer
    transaction do
      question.update!(best_answer: self)
      question.reward&.update!(recipient: user)
    end
  end

  private

  def new_answer_notify
    NewAnswerNotificationJob.perform_later(question: self.question)
  end
end
