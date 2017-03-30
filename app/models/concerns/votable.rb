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
end
