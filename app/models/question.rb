class Question < ApplicationRecord
  include Attachable
  include Rateable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  # TODO: has_one :best_answer, -> { find_by best: true }, class_name: 'Answer'

  validates :title, :body, length: { minimum: 6 }

  def best_answer
    answers.best_one
  end
end
