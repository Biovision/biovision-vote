module Biovision
  module Vote
    module ApplicationHelper
      # @param [Vote] vote
      def vote_image(vote)
        if vote.upvote?
          image_tag('biovision/vote/icons/upvote-active.svg', alt: '⇧')
        else
          image_tag('biovision/vote/icons/downvote-active.scg', alt: '⇩')
        end
      end
    end
  end
end
