class User < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :voices, dependent: :destroy
  has_many :rateable
  has_many :oauth_authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  def owner?(entity)
    id == entity.user_id
  end

  def subscribe_to(question)
    subscriptions.find_or_create_by question: question
  end

  def subscribed_to?(question)
    subscriptions.where(question: question).exists?
  end

  def self.find_with_uid(provider:, uid:)
    oauth_arguments = { provider: provider, uid: uid }
    joins(:oauth_authorizations).find_by(oauth_authorizations: oauth_arguments)
  end

  def self.create_without_pass(args)
    pass = Devise.friendly_token 64
    create({ password: pass, password_confirmation: pass }.merge(args))
  end
end
