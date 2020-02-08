# frozen_string_literal: true

module Biovision
  module Components
    # Component for votes
    class VotesComponent < BaseComponent
      METRIC_VOTE_HIT = 'votes.any.hit'
      METRIC_UPVOTE_HIT = 'votes.upvote.hit'
      METRIC_DOWNVOTE_HIT = 'votes.downvote.hit'

      def self.privilege_names
        %w[moderator]
      end

      # @param [Vote] entity
      def count_vote(entity)
        name = entity.upvote? ? METRIC_UPVOTE_HIT : METRIC_DOWNVOTE_HIT
        register_metric(name)
        register_metric(METRIC_VOTE_HIT)
      end
    end
  end
end
