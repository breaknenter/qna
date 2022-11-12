class Question < ApplicationRecord
  include Voteable
  include Commentable

  belongs_to :author,      class_name: 'User',   foreign_key: 'author_id'
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', dependent: :destroy, optional: true

  has_many :answers,     dependent: :destroy
  has_many :links,       dependent: :destroy, as: :linkable
  has_many :subscribes,  dependent: :destroy
  has_many :subscribers, through:   :subscribes

  has_one  :reward,  dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links,  reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :text, presence: true

  scope :per_day, -> do
    where(created_at: 1.day.ago.all_day).select(:id, :title, :created_at)
  end

  def answers_ex_best
    best_answer_id ? answers.where.not(id: best_answer_id) : answers
  end
end
