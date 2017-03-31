class VotesController < ApplicationController
  # post /votes
  def create
    @entity = Vote.new(creation_parameters)
    if @entity.votable.votable_by?(current_user)
      render :result, status: :unauthorized
    elsif Vote.voted?(current_user, @entity.votable)
      render :result, status: :conflict
    else
      count_vote
    end
  end

  # delete /votes/:id
  def destroy
    @entity.destroy
    render :result
  end

  private

  def set_entity
    @entity = Vote.owned_by(current_user).find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find vote')
    end
  end

  def creation_parameters
    parameters = params.require(:vote).permit(Vote.creation_parameters)
    parameters.merge(owner_for_entity(true))
  end

  def count_vote
    @entity.save
    name = @entity.upvote? ? Vote::METRIC_UPVOTE_HIT : Vote::METRIC_DOWNVOTE_HIT
    Metric.register(name)
    Metric.register(Vote::METRIC_VOTE_HIT)

    render :result, status: :created
  end
end
