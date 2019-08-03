# frozen_string_literal: true

# Handling votes
class VotesController < ApplicationController
  before_action :set_handler
  before_action :set_entity, only: :destroy

  # post /votes
  def create
    @entity = Vote.new(creation_parameters)
    if @entity.votable.vote_applicable?(@entity)
      process_vote
    else
      render :result, status: :unprocessable_entity
    end
  end

  # delete /votes/:id
  def destroy
    @entity.destroy
    render :result
  end

  private

  def set_entity
    @entity = Vote.find_by(id: params[:id])
    if @entity.nil? || !@entity.editable_by?(current_user)
      handle_http_404('Cannot find vote')
    end
  end

  def set_handler
    slug = Biovision::Components::VoteComponent::SLUG
    @handler = Biovision::Components::BaseComponent.handler(slug, current_user)
  end

  def creation_parameters
    parameters = params.require(:vote).permit(Vote.creation_parameters)
    parameters.merge(owner_for_entity(true)).merge(slug: visitor_slug)
  end

  def process_vote
    if Vote.voted?(@entity.current_slug, @entity.votable)
      render :result, status: :conflict
    else
      count_vote
    end
  end

  def count_vote
    @entity.save
    @handler.count_vote(@entity)

    render :result, status: :created
  end
end
