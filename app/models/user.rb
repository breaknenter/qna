class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :questions, class_name: 'Question', foreign_key: 'author_id'
  has_many :answers,   class_name: 'Answer',   foreign_key: 'author_id'
  has_many :rewards
  has_many :votes
  has_many :comments

  def self.find_for_oauth(auth)
  end

  def author_of?(entity)
    self.id == entity.author_id
  end
end
