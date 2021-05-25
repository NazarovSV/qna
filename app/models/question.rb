# frozen_string_literal: true

class Question < ApplicationRecord
  include Commentable
  include Votable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_one :reward, dependent: :destroy
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :calculate_reputation

  scope :new_question_from_the_last_day, lambda { where('created_at >= ?', 1.days.before) }

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
