class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[show update]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    question = current_resource_owner.questions.new(question_params)

    if question.save
      render json: question, status: :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question, status: :ok
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     links_attributes: %i[name url],
                                     reward_attributes: %i[name image])
  end
end