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

  def edit; end

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
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    question.destroy!
    redirect_to questions_path, notice: 'Your question has been successfully deleted!'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
