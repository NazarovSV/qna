# frozen_string_literal: true

class User < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :rewards, foreign_key: 'recipient_id', dependent: :nullify
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  def author?(entity)
    id == entity.user_id
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def self.save_with_oauth(email:, uid:, provider:)
    password = Devise.friendly_token[0, 20]
    user = new(email: email, password: password, password_confirmation: password)
    transaction do
      user.authorizations.new(uid: uid, provider: provider)
      user.save
    end
    user
  end
end
