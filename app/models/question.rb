class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, :text, presence: true
end
