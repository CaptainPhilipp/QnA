class User < ApplicationRecord
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

  def self.find_with_uid(args)
    oauth_arguments = { provider: args[:provider], uid: args[:uid] }
    joins(:oauth_authorizations).find_by(oauth_authorizations: oauth_arguments)
  end

  def self.create_without_pass(args)
    pass = Devise.friendly_token 64
    create({ password: pass, password_confirmation: pass }.merge args)
  end
end
