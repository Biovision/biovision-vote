module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  # @param [User] user
  def votable_by?(user)
    return false if user.nil?
    !Vote.voted?(user, self)
  end

  # @param [User] user
  def vote_data(user = nil)
    {
        upvote_count: upvote_count,
        downvote_count: downvote_count,
        vote_result: vote_result,
        vote_type: voted(user)
    }
  end

  # @param [User] user
  def voted(user)
    vote = votes.find_by(user: user)
    return if vote.nil?
    vote.upvote? ? :upvote : :downvote
  end
end
