class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :commentable, polymorphic: true, touch: true

  validates :text, presence: true
  validates :text, length: { in: 2..256 }
  validates :commentable_type, inclusion: %w[Question Answer]
end
