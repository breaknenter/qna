module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :destroy
  end

  def vote!(user:, value:)
    vote = votes.find_by(user: user)

    unless vote
      vote = votes.create(user: user, value: value)
    else
      value != vote.value ? vote.destroy : vote.errors.add(:user, :uniqueness, message: 'you have already voted')
    end

    vote
  end

  def rating
    votes.sum(:value)
  end
end
