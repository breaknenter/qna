class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :confirmable, omniauth_providers: [:github, :vkontakte]

  has_many :questions, class_name: 'Question', foreign_key: 'author_id'
  has_many :answers,   class_name: 'Answer',   foreign_key: 'author_id'
  has_many :rewards
  has_many :votes
  has_many :comments, class_name: 'Comment', foreign_key: 'author_id'
  has_many :authorizations
  has_many :subscriptions, foreign_key: 'subscriber_id', dependent: :destroy

  validates :admin, inclusion: { in: [true, false] }

  def admin!
    update!(admin: true)
  end

  def author_of?(entity)
    self.id == entity.author_id
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
