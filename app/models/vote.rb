class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  LIKE = 1
  DISLIKE = -1
end
