# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { is_expected.to have_many(:answers).dependent(:destroy) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to belong_to(:best_answer).optional }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it 'should return answers without best answer' do
    question = create(:question)
    answers = create_list(:answer, 3, question: question)
    question.update(best_answer: answers.first)

    expect(question.other_answers.length).to eq 2
    expect(question.other_answers).to include answers.second
    expect(question.other_answers).to include answers.last
  end
end
