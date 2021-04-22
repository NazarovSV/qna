module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[like dislike]
  end

  def dislike
    if !current_user.author?(@votable) && @votable.dislike(current_user) == Vote::DISLIKE
      render json: { id: @votable.id, resource: @votable.class.name.downcase, rating: @votable.rating, dislike: true }
    else
      render json: { id: @votable.id, resource: @votable.class.name.downcase, rating: @votable.rating }
    end
  end

  def like
    if !current_user.author?(@votable) && @votable.like(current_user) == Vote::LIKE
      render json: { id: @votable.id, resource: @votable.class.name.downcase, rating: @votable.rating, like: true }
    else
      render json: { id: @votable.id, resource: @votable.class.name.downcase, rating: @votable.rating }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

end
