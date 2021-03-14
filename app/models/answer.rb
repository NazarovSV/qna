# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  scope :without_best, ->{ joins(:question).where('questions.best_answer_id IS NULL OR questions.best_answer_id != answers.id') }

  validates :body, presence: true
end
