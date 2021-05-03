# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  # before_action :gon_current_user, only: :publish
  after_action :publish, only: :create

  expose :answer
  expose :question

  include Voted

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    return unless @answer.save

    respond_to do |format|
      format.js { flash.now[:notice] = 'Your answer successfully created!' }
    end
  end

  def destroy
    if current_user.author?(answer)
      answer.question.update(best_answer: nil) if answer == answer.question.best_answer
      answer.destroy!
      flash.now[:notice] = 'Your answer has been successfully deleted!'
    else
      flash.now[:alert] = 'You do not have permission to delete the answer!'
    end
    @question = answer.question

    respond_to :js
  end

  def update
    answer.update(answer_params) if current_user.author?(answer)
    @question = answer.question
  end

  def best_answer
    answer.best_answer
    @question = answer.question
    @other_answer = answer.question.answers.without_best
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end

  def publish
    return if @answer.errors.any?

    QuestionChannel.broadcast_to(@answer.question, { answer: @answer,
                                                     user_id: current_user.id,
                                                     dislike_url: dislike_answer_path(@answer.id),
                                                     like_url: like_answer_path(@answer.id),
                                                     files: attached_files,
                                                     links: @answer.links,
                                                     question_author_id: @answer.question.user.id,
                                                     best_answer_url: best_answer_answer_path(@answer) })
  end

  def attached_files
    return [] unless @answer.files.any?

    @answer.files.map { |file| { id: file.id, name: file.filename.to_s, url: url_for(file) } }
  end
end
