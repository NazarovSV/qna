class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[show update destroy]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    return head :not_found unless @question
    render json: @question
  end

  def create
    question = current_resource_owner.questions.new(question_params)

    if question.save
      head :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def update
    return head :not_found unless @question

    if @question.update(question_params)
      head :ok
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    return head :not_found unless @question

    if @question.destroy
      head :ok
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @question = nil
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     links_attributes: %i[name url],
                                     reward_attributes: %i[name image])
  end
end