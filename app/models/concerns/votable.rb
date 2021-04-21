module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:value)
  end

  def like(user)
    vote(user, VoteType::LIKE) unless user.author?(self)
  end

  def dislike(user)
    vote(user, VoteType::DISLIKE) unless user.author?(self)
  end

  def already_vote_so?(user, vote_type)
    already_vote?(user) && votes.find_by(user: user).value == vote_type
  end

  private

  def vote(user, type)
    if (already_vote?(user))
      result = votes.find_by(user: user)

      value = result.value == type ? result.value - type : type
      result.update(value: value)
      value
    else
      votes.create!(user: user, value: type)
      type
    end
  end

  def already_vote?(user)
    votes.exists?(user: user)
  end
end
