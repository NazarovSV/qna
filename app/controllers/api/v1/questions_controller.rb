class Api::V1::QuestionsController < Api::V1::BaseController
  skip_authorization_check only: :index

  def index
    @questions = Question.all
    render json: @questions
  end
end