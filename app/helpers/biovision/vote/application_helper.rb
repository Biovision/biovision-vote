module Biovision
  module Vote
    module ApplicationHelper
      # @param [Vote] vote
      def vote_image(vote)
        if vote.upvote?
          image_tag('biovision/vote/icons/upvote-active.svg', alt: '⇧')
        else
          image_tag('biovision/vote/icons/downvote-active.svg', alt: '⇩')
        end
      end

      # @param [ApplicationRecord] entity
      def biovision_votable_link(entity)
        text = entity.model_name.human
        if entity.respond_to?(:title)
          text << " «#{entity.title}»"
        elsif entity.respond_to?(:name)
          text << " «#{entity.name}»"
        else
          text << " №#{entity.id}"
        end
        link_to(text, entity)
      end
    end
  end
end
