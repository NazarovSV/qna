class AnswersController < ApplicationController
  before_action :load_answer, only: :show
  before_action :find_question, only: :new

  def show; end

  def new
    @answer = @question.answers.new
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
