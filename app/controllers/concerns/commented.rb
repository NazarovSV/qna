module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: %i[comment]
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
end
