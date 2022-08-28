class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :questions, class_name: 'Question', foreign_key: 'author_id'
  has_many :answers,   class_name: 'Answer',   foreign_key: 'author_id'
  has_many :rewards
  has_many :votes
  has_many :comments, class_name: 'Comment', foreign_key: 'author_id'
  has_many :authorizations

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first

    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token(10)
      user = User.create!(
               email: email,
               password: password,
               password_confirmation: password
               )

      user.create_authorization(auth)
    end

    user
  end

  def author_of?(entity)
    self.id == entity.author_id
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
