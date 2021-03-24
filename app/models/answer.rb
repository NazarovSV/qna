# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  scope :without_best, ->{ joins(:question).where('questions.best_answer_id IS NULL OR questions.best_answer_id != answers.id') }

  validates :body, presence: true
end
