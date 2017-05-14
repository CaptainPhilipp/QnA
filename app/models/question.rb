class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  # belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, length: { minimum: 6 }

  def best_answer_id
    best_answer.id
  end

  def best_answer
    Answer.find_by(question_id: id, best: true)
  end
end
