class AnswersController < ApplicationController
  expose :answer
  expose :question

  def show; end

  def new; end

  def create
    @answer = question.answers.new(answer_params)
    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
