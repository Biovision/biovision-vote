# frozen_string_literal: true

# Model has votes
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
      upvote_count: data.dig('votes', 'up'),
      downvote_count: data.dig('votes', 'down'),
      vote_result: data.dig('votes', 'total'),
      vote_type: voted(vote_or_slug)
    }
  end

  # @param [String|Vote] vote_or_slug
  def voted(vote_or_slug)
    vote = vote_or_slug.is_a?(String) ? votes.find_by(slug: vote_or_slug) : vote_or_slug
    return :none if vote&.id.nil?

    vote.upvote? ? :upvote : :downvote
  end

  # @param [Integer] delta
  def add_vote_result(delta)
    return unless has_attribute?(:data)

    vote_data = data['votes'].to_h
    key = delta.positive? ? 'up' : 'down'
    vote_data[key] = vote_data.key?(key) ? vote_data[key].to_i + 1 : 1
    vote_data['total'] = vote_data.key?('total') ? vote_data['total'] + delta : delta
    self.data['votes'] = vote_data

    save
  end

  # @param [Integer] delta
  def discard_vote_result(delta)
    return unless has_attribute?(:data)

    vote_data = data['votes'].to_h
    key = delta.positive? ? 'up' : 'down'
    vote_data[key] = vote_data[key].to_i - 1 if vote_data[key].to_i.positive?
    vote_data['total'] = vote_data['total'].to_i - delta
    self.data['votes'] = vote_data

    save
  end
end
