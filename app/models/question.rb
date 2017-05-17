class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  # belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, length: { minimum: 6 }

  def best_answer
    answers.find_by(best: true)
  end
end
