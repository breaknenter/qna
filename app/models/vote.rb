class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value,
    presence: true,
    inclusion: { in: [1, -1] }

  validates :user,
    uniqueness: { scope: %i[votable_type votable_id],
                  message: 'you have already voted' }
end
