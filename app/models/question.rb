class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  # has_one :best_answer, -> { answers.find_by(best: true) }

  validates :title, :body, length: { minimum: 6 }

  def best_answer
    answers.find_by(best: true)
  end
end
