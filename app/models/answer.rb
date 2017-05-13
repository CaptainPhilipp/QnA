class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, length: { minimum: 6 }

  def best?
    question.best_answer_id == id
  end
end
