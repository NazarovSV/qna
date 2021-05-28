class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])

    authorize! :subscribe, @question

    Subscription.create!(user: current_user, question: @question)

    respond_to :js
  end

  def destroy
    @subscription = Subscription.find(params[:id])

    authorize! :unsubscribe, @subscription

    @question = @subscription.question
    @subscription.destroy!

    respond_to :js
  end
end
