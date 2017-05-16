class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, length: { minimum: 6 }

  def best!
    return true if best?
    transaction do
      question.answers.where(best: true).each { |a| a.update!(best: false) }
      update! best: true
    end
  end
end
