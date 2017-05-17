class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, length: { minimum: 6 }

  def best!
    return true if best?
    transaction do # простой транзакции без фич вроде должно быть достаточно
      question.answers.where(best: true).update(best: false)
    end
    update best: true
  end
end
