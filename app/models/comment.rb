class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :text, presence: true
  validates :text, length: { in: 2..256 }
end
