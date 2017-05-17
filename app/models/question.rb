class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  # has_one :best_answer, -> { find_by best: true }, class_name: 'Answer'

  validates :title, :body, length: { minimum: 6 }

  def best_answer
    answers.best_one
  end
end
