# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  expose :question

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.new
  end

  def new; end


  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author?(question)
    @questions = Question.all
  end

  def destroy
    if current_user.author?(question)
      question.destroy!
      redirect_to questions_path, notice: 'Your question has been successfully deleted!'
    else
      redirect_to questions_path, alert: 'You do not have permission to delete the question!'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
