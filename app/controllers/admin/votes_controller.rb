# frozen_string_literal: true

# Administrative part of vote handling
class Admin::VotesController < AdminController
  # get /admin/votes
  def index
    @collection = Vote.list_for_administration.page(current_page)
  end

  private

  def restrict_access
    require_privilege :moderator
  end
end
