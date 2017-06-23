class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :voices, dependent: :destroy
  has_many :rateable
  has_many :oauth_authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  AUTHENTICATE_FIELDS   = ['email'].freeze # поля, по которым можно привязать user к oauth_authentication
  OAUTH_FILLABLE_FIELDS = ['email'].freeze # поля, которые можно заполнить по информации из oauth

  def owner?(entity)
    id == entity.user_id
  end

  def self.find_for_oauth(hash)
    oauth_arguments = OauthAuthorization.auth_fields_from(hash)
    joins(:oauth_authorizations).find_by(oauth_authorizations: oauth_arguments)
  end

  def self.create_without_pass(attributes_hash)
    pass = Devise.friendly_token[0, 20]
    create( { password: pass,
              password_confirmation: pass,
              'email' => 'nomail@example.com' }.merge attributes_hash)
  end

  def self.find_by_any(search_arguments)
    field_keys = search_arguments.keys & AUTHENTICATE_FIELDS
    recursive_find_any(field_keys, search_arguments) if field_keys.any?
  end

  def self.select_fillabe_fields(fields_hash)
    fields_hash.select { |field_name, _| OAUTH_FILLABLE_FIELDS.include?(field_name) }
  end

  private

  def self.recursive_find_any(field_keys, search_args)
    current_key   = field_keys.shift
    current_value = search_args[current_key]

    if field_keys.empty?
      find_by(current_key => current_value)
    else
      where(current_key => current_value)
        .or(recursive_find_any field_keys, search_args)
    end
  end
end
