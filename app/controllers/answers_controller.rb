class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]

  expose :answer
  expose :question

  def show; end

  def new; end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to question, notice: 'Your answer successfully created!'
    else
      render 'questions/show'
    end
  end

  def destroy
    answer.destroy!
    redirect_to question_path(answer.question), notice: 'Your answer has been successfully deleted!'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
