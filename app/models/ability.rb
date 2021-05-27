# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can :create, User
    can :create, Authorization
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: @user.id
    can :destroy, [Question], user_id: @user.id
    can :destroy, [Answer], user_id: @user.id
    can :comment, [Question, Answer]
    can :best_answer, Answer, question: { user_id: @user.id }
    can [:like, :dislike], [Answer, Question] do |record|
      !@user.author?(record)
    end
    can [:create, :destroy], [Link], linkable: { user_id: @user.id }
    can :destroy, ActiveStorage::Attachment do |files|
      @user.author?(files.record)
    end
    can [:me, :other], User
    can :subscribe, Question
  end
end
