class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, class_name: 'Question', foreign_key: 'author_id'
  has_many :answers,   class_name: 'Answer',   foreign_key: 'author_id'
  has_many :rewards

  def author_of?(entity)
    self.id == entity.author_id
  end
end
