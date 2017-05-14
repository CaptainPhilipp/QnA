class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, length: { minimum: 6 }

  def best!
    return true if best? # без reload, следующая строка не обновляет answers
    return false unless question.answers.where(best: true).update(best: false)
    update best: true
  end
end
