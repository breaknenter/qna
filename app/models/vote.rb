class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates :value,
    presence: true,
    inclusion: { in: [1, -1] }

  validates :user,
    uniqueness: { scope: %i[voteable_type voteable_id],
                  message: 'you have already voted' }

  validates :voteable_type, inclusion: %w[Question Answer]

  validate :self_like

  private

  def self_like
    errors.add(:user, 'self-like it for xxxx') if voteable&.author_id == user_id
  end
end
