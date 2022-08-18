class Answer < ApplicationRecord
  include Voteable
  include Commentable

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :question

  has_one :question_with_best_answer, class_name: 'Question', foreign_key: :best_answer_id, dependent: :nullify

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :text, presence: true

  def best!
    transaction do
      question.update!(best_answer_id: id)
      question.reward&.update!(user_id: author_id)
    end
  end

  def best?
    question.best_answer_id == id
  end
end
