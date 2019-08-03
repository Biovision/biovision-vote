# frozen_string_literal: true

module VotableItem
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end

  # @param [Vote|String] vote_or_slug
  def vote_applicable?(vote_or_slug)
    slug = vote_or_slug.is_a?(String) ? vote_or_slug : vote_or_slug.slug
    !Vote.voted?(slug, self)
  end

  # @param [String|Vote] vote_or_slug
  def vote_data(vote_or_slug)
    {
        upvote_count: upvote_count,
        downvote_count: downvote_count,
        vote_result: vote_result,
        vote_type: voted(vote_or_slug)
    }
  end

  # @param [String|Vote] vote_or_slug
  def voted(vote_or_slug)
    vote = vote_or_slug.is_a?(String) ? votes.find_by(slug: vote_or_slug) : vote_or_slug
    return :none if vote&.id.nil?

    vote.upvote? ? :upvote : :downvote
  end
end
