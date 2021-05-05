# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:links).dependent(:destroy) }

  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }

  it 'should return answers without best answer' do
    question = create(:question)
    answers = create_list(:answer, 3, question: question)
    question.update(best_answer: answers.first)

    expect(question.answers.without_best.length).to eq 2
    expect(question.answers.without_best).to include answers.second
    expect(question.answers.without_best).to include answers.last
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'Votable'
  it_behaves_like 'Commentable'
end
