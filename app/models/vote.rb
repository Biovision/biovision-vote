class Vote < ApplicationRecord
  include HasOwner

  METRIC_VOTE_HIT     = 'votes.any.hit'
  METRIC_UPVOTE_HIT   = 'votes.upvote.hit'
  METRIC_DOWNVOTE_HIT = 'votes.downvote.hit'

  belongs_to :user, optional: true
  belongs_to :agent, optional: true
  belongs_to :votable, polymorphic: true

  before_validation { self.delta = (delta.to_i > 0 ? 1 : -1) }
  before_validation { self.slug = current_slug if slug.blank? }
  validates_uniqueness_of :votable_id, scope: [:slug, :votable_type]

  after_create :add_vote_result
  after_destroy :discard_vote_result

  scope :recent, -> { order('id desc') }
  scope :list_for_administration, -> { recent }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  # @param [User] user
  # @param [String] ip
  # @param [Integer] agent_id
  def self.slug_string(user, ip, agent_id)
    if user.nil?
      "#{ip}:#{agent_id}"
    else
      user.id.to_s
    end
  end

  # @param [String] slug
  # @param [ApplicationRecord] votable
  def self.voted?(slug, votable)
    exists?(slug: slug, votable: votable)
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
    %i[delta votable_id votable_type]
  end

  def upvote?
    delta >= 0
  end

  def downvote?
    delta < 0
  end

  # @param [User] user
  def editable_by?(user)
    owned_by?(user) || UserPrivilege.user_has_privilege?(:user, :moderator)
  end

  def current_slug
    self.class.slug_string(user, ip, agent_id)
  end

  private

  def add_vote_result
    votable.vote_result    = votable.vote_result + delta
    votable.upvote_count   = votable.upvote_count + 1 if upvote?
    votable.downvote_count = votable.downvote_count + 1 if downvote?
    votable.vote_impact(delta) if votable.respond_to?(:vote_impact)
    votable.save
  end

  def discard_vote_result
    votable.vote_result    = votable.vote_result - delta
    votable.upvote_count   = votable.upvote_count - 1 if upvote?
    votable.downvote_count = votable.downvote_count - 1 if downvote?
    votable.save
  end
end
