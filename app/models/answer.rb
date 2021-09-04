class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :question

  has_one :question_with_best_answer, class_name: 'Question', foreign_key: :best_answer_id, dependent: :nullify

  has_many_attached :files

  validates :text, presence: true

  def best!
    question.update(best_answer_id: id)
  end

  def best?
    question.best_answer_id == id
  end
end
