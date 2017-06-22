class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :voices, dependent: :destroy
  has_many :rateable
  has_many :oauth_authorizations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  AUTHENTICATE_FIELDS = [:email]

  def owner?(entity)
    id == entity.user_id
  end

  def self.find_for_oauth(hash)
    joins(:oauth_authorizations)
    .find_by(oauth_authorizations: OauthAuthorization.select_fields_from(hash))
  end

  def self.create_for_oauth(args_hash)
    info = args_hash.info || {}
    pass = primitive_random_password
    create  password: pass,
            password_confirmation: pass,
            email: info[:email] || ""
  end

  def self.find_by_any(args_hash)
    field_keys = args_hash.keys & AUTHENTICATE_FIELDS
    recursive_find(field_keys, in_hash: args_hash) if field_keys.any?
  end

  private

  def self.primitive_random_password
    (rand(10 ** 4).to_s + Time.now.to_s).chars.shuffle.join
  end

  def self.recursive_find(field_keys, in_hash:)
    return User.limit(0) unless key = field_keys.shift
    where(key => in_hash[key])
      .or(recursive_find field_keys, in_hash: in_hash)
  end
end
