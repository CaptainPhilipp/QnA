class Question < ApplicationRecord
  include Attachable
  include Rateable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_one :best_answer, -> { where best: true }, class_name: 'Answer'

  validates :title, :body, length: { minimum: 6 }
end
