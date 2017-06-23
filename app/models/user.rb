class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :voices, dependent: :destroy
  has_many :rateable
  has_many :oauth_authorizations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  AUTHENTICATE_FIELDS = [:email]

  def owner?(entity)
    id == entity.user_id
  end

  def self.find_for_oauth(hash)
    joins(:oauth_authorizations)
    .find_by(oauth_authorizations: OauthAuthorization.auth_fields_from(hash))
  end

  def self.create_without_pass(info)
    pass = Devise.friendly_token[0, 20]
    create { password: pass, password_confirmation: pass }.merge info
  end

  def self.find_by_any(search_args)
    field_keys = search_args.keys & AUTHENTICATE_FIELDS
    recursive_find_any(field_keys, search_args) if field_keys.any?
  end

  private

  def self.recursive_find_any(field_keys, search_args)
    field_key   = field_keys.shift
    field_value = search_args[field_key]

    if field_keys.empty?
      find_by(field_key => field_value)
    else
      where(field_key => field_value)
        .or(recursive_find_any field_keys, search_args)
    end
  end
end
