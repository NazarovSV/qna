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
      answer.question.update(best_answer: nil) if answer == answer.question.best_answer
      answer.destroy!
      flash.now[:notice] =  'Your answer has been successfully deleted!'
    else
      flash.now[:alert] =  'You do not have permission to delete the answer!'
    end
    @question = answer.question

    respond_to :js
  end

  def update
    answer.update(answer_params) if current_user.author?(answer)
    @question = answer.question
  end

  def best_answer
    answer.question.update(best_answer: answer)
    @question = answer.question
    @other_answer = answer.question.answers.without_best
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
