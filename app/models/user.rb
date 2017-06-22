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

  AUTHORIZATION_FIELDS = %i(email)

  def owner?(entity)
    id == entity.user_id
  end

  def self.find_by_one_of_args(args_hash)
    find_by (['? = ?'] * args_hash.size) * ' OR ', *args_hash.to_a
  end

  def self.create_for_oauth(hash)
    create email: hash[:email] || ""
  end
end
