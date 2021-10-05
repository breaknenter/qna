class Question < ApplicationRecord
  belongs_to :author,      class_name: 'User',   foreign_key: 'author_id'
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', dependent: :destroy, optional: true

  has_many :answers, dependent: :destroy
  has_many :links,   dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links

  validates :title, :text, presence: true

  def answers_ex_best
    best_answer_id ? answers.where.not(id: best_answer_id) : answers
  end
end
