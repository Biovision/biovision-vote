# frozen_string_literal: true

# Administrative part of vote handling
class Admin::VotesController < AdminController
  # get /admin/votes
  def index
    @collection = Vote.list_for_administration.page(current_page)
  end

  private

  def component_class
    Biovision::Components::VotesComponent
  end

  def restrict_access
    error = 'Managing votes is not allowed'
    handle_http_401(error) unless component_handler.allow?('moderator')
  end
end
