class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def index
    answers = Answer.where(question_id: params[:question_id])
    render json: answers
  end

  def show
    answer = Answer.find(params[:id])
    render json: answer
  end
end