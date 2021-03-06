# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :gon_current_user, only: :show
  after_action :publish, only: :create
  expose :question, scope: -> { Question.with_attached_files }

  include Voted
  include Commented

  load_and_authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.new
    @answer.links.new
    @answers = question.answers.without_best
    @question = question
  end

  def new
    question.links.new
    question.build_reward
  end

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
    question.update(question_params)
    @questions = Question.all
  end

  def destroy
    question.destroy!
    redirect_to questions_path, notice: 'Your question has been successfully deleted!'
  end

  private

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: %i[name url],
                                     reward_attributes: %i[name image])
  end

  def publish
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions_channel',
      { question: @question,
        question_url: question_url(@question) }
    )
  end
end
