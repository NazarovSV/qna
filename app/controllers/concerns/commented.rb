module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :comment
    after_action :publish_comment, only: :comment
  end

  def comment
    @comment = @commentable.comments.new(body: params[:body], user: current_user)
    @comment.save

    render 'comments/create'
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def publish_comment
    return if @comment.errors.any?

    Rails.logger.info params[:id]

    ActionCable.server.broadcast("comments_question_channel_#{question_id}", {
                                   comment: @comment,
                                   email: @comment.user.email,
                                   resource_name: @comment.commentable.class.name.downcase
                                 })
  end

  def question_id
    return @comment.commentable.id if @comment.commentable.is_a? Question
    return @comment.commentable.question.id if @comment.commentable.is_a? Answer
  end
end
