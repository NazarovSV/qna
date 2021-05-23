class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[show update destroy]

  authorize_resource

  def index
    answers = Answer.where(question_id: params[:question_id])
    render json: answers
  end

  def show
    return head :not_found unless @answer

    render json: @answer
  end

  def create
    return head :not_found unless @question

    answer = @question.answers.new(answer_params)
    answer.user = @current_resource_owner

    if answer.save
      head :created
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    return head :not_found unless @answer

    if @answer.destroy
      head :ok
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    return head :not_found unless @answer

    authorize!(:update, @answer)

    if @answer.update(answer_params)
      head :ok
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[name url])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @answer = nil
  end

  def find_question
    @question = Question.find(params[:question_id])
  rescue ActiveRecord::RecordNotFound
    @question = nil
  end

end