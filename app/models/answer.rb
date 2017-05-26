class Answer < ApplicationRecord
  include Attachable
  include Rateable

  belongs_to :user
  belongs_to :question

  scope :best, -> { where best: true }

  validates :body, length: { minimum: 6 }

  def best!
    return true if best?
    transaction do
      question.answers.best.update(best: false)
      raise "Can't change one of [#{question.answers.best}]" if question.answers.best.count > 1
      update! best: true
    end
  end

  def self.best_one
    find_by best: true
  end
end
