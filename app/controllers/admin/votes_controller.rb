class Admin::VotesController < AdminController
  # get /admin/votes
  def index
    @collection = Vote.page_for_administration(current_page)
  end

  private

  def restrict_access
    require_privilege :moderator
  end
end
