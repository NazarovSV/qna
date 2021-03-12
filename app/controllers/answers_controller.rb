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
      flash.now[:notice] =  'Your answer has been successfully deleted!'
    else
      flash.now[:alert] =  'You do not have permission to delete the answer!'
    end
    @question = answer.question

    respond_to do |format|
      format.js
    end
  end

  def update
    answer.update(answer_params) if current_user.author?(answer)
    @question = answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
