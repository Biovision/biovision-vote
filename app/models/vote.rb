class Vote < ApplicationRecord
  include HasOwner

  PER_PAGE = 20

  belongs_to :user, optional: true
  belongs_to :agent, optional: true
  belongs_to :votable, polymorphic: true

  validates_uniqueness_of :votable, scope: [:user]

  after_save :cache_vote_result

  scope :recent, -> { order('id desc') }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    recent.page(page).per(PER_PAGE)
  end

  # @param [User] user
  # @param [ApplicationRecord] votable
  def self.voted?(user, votable)
    exists?(user: user, votable: votable)
  end

  # @param [User] user
  # @param [ApplicationRecord] votable
  # @param [Integer] delta
  def self.count_vote(user, votable, delta = 1)
    create(user: user, votable: votable, delta: delta) unless voted?
    votable.reload
    votable.vote_result
  end

  def upvote?
    delta >= 0
  end

  def downvote?
    delta < 0
  end

  private

  def cache_vote_result
    votable.vote_result    = votable.vote_result + delta
    votable.upvote_count   = votable.upvote_count + 1 if upvote?
    votable.downvote_count = votable.downvote_count + 1 if downvote?
    votable.save
  end
end
