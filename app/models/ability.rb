# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user.present?
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]
    can :create_comment, [Question, Answer]
    can [:update, :destroy], [Question, Answer], author_id: user.id

    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end

    can :destroy, Link do |link|
      user.author_of?(link.linkable)
    end

    can :best, Answer do |answer|
      user.author_of?(answer.question)
    end

    can [:vote_up, :vote_down], [Question, Answer] do |voteable|
      !user.author_of?(voteable)
    end
  end
end
