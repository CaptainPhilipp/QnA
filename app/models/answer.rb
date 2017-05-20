class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy

  scope :best, -> { where best: true }

  accepts_nested_attributes_for :attachments, allow_destroy: true

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
