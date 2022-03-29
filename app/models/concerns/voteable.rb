module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :destroy
  end

  def vote!(user:, value:)
    vote = votes.find_by(user_id: user.id)

    unless vote
      vote = votes.create(user_id: user.id, value: value)
    else
      value != vote.value ? vote.destroy : vote.errors.add(:user, :uniqueness, 'you have already voted')
    end

    vote
  end

  def rating
    votes.sum(:value)
  end
end
