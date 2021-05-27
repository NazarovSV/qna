class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])

    authorize! :subscribe, @question

    Subscription.create!(user_id: current_user.id, question_id: @question.id)

    respond_to :js
  end

  def destroy
    @subscription = Subscription.find(params[:id])

    authorize! :subscribe, @subscription.question

    @question = @subscription.question
    @subscription.destroy!

    respond_to :js
  end
end
