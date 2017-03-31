class Vote < ApplicationRecord
  include HasOwner

  PER_PAGE = 20

  METRIC_VOTE_HIT     = 'votes.any.hit'
  METRIC_UPVOTE_HIT   = 'votes.upvote.hit'
  METRIC_DOWNVOTE_HIT = 'votes.downvote.hit'

  belongs_to :user, optional: true
  belongs_to :agent, optional: true
  belongs_to :votable, polymorphic: true

  before_validation { self.delta = (delta.to_i > 0 ? 1 : -1) }
  validates_uniqueness_of :votable, scope: [:user]

  after_create :add_vote_result
  after_destroy :discard_vote_result

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

  def self.creation_parameters
    %i(votable_id votable_type delta)
  end

  def upvote?
    delta >= 0
  end

  def downvote?
    delta < 0
  end

  private

  def add_vote_result
    votable.vote_result    = votable.vote_result + delta
    votable.upvote_count   = votable.upvote_count + 1 if upvote?
    votable.downvote_count = votable.downvote_count + 1 if downvote?
    votable.save
  end

  def discard_vote_result
    votable.vote_result    = votable.vote_result - delta
    votable.upvote_count   = votable.upvote_count - 1 if upvote?
    votable.downvote_count = votable.downvote_count - 1 if downvote?
    votable.save
  end
end
