# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to have_one(:reward).dependent(:destroy) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to belong_to(:best_answer).optional }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'Votable'
  it_behaves_like 'Commentable'

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end


  it 'should return new question from the last day' do
    question = create(:question, created_at: DateTime.now - 2.days)
    questions = create_list(:question, 2)

    expect(Question.new_question_from_the_last_day).to include questions.first
    expect(Question.new_question_from_the_last_day).to include questions.second
    expect(Question.new_question_from_the_last_day).to_not include question
  end

end
