# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]

  expose :answer
  expose :question

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      respond_to do |format|
        format.js { flash.now[:notice] =  'Your answer successfully created!' }
      end
    end
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy!
      redirect_to question_path(answer.question), notice: 'Your answer has been successfully deleted!'
    else
      redirect_to question_path(answer.question), alert: 'You do not have permission to delete the answer!'
    end
  end

  def update
    answer.update(answer_params)
    @question = answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
