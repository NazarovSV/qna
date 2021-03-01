class AnswersController < ApplicationController
  before_action :load_answer, only: :show

  def show; end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
