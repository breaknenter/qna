module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: %i[vote_up vote_down]
    before_action :set_voteable,       only: %i[vote_up vote_down]
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
  end
end
