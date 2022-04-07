module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: %i[vote_up vote_down]
    before_action :set_voteable,       only: %i[vote_up vote_down]
  end

  def vote_up
    vote = @voteable.vote!(user: current_user, value: 1)

    render_vote(vote)
  end

  def vote_down
    vote = @voteable.vote!(user: current_user, value: -1)

    render_vote(vote)
  end

  private

  def render_vote(vote)
    if vote.errors.any?
      render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
    else
      render json: { rating: vote.voteable.rating }
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
  end
end
