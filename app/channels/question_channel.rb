class QuestionChannel < ApplicationCable::Channel
  def subscribed
    stream_for question
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def question
    Question.find_by(id: params[:room_id])
  end
end
