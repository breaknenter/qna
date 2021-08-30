class Question < ApplicationRecord
  belongs_to :author,      class_name: 'User',   foreign_key: 'author_id'
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', dependent: :destroy, optional: true

  has_many :answers, dependent: :destroy

  validates :title, :text, presence: true

  def set_best_answer(answer)
    update(best_answer_id: answer.id)
  end

  def answers_ex_best
    best_answer_id ? answers.where.not(id: best_answer_id) : answers
  end
end
