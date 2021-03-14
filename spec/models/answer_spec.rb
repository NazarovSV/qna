# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of :body }

  it 'should return answers without best answer' do
    question = create(:question)
    answers = create_list(:answer, 3, question: question)
    question.update(best_answer: answers.first)

    expect(question.answers.without_best.length).to eq 2
    expect(question.answers.without_best).to include answers.second
    expect(question.answers.without_best).to include answers.last
  end
end
