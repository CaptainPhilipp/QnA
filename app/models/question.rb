class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  # TODO: has_one :best_answer, -> { find_by best: true }, class_name: 'Answer'

  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates :title, :body, length: { minimum: 6 }

  def best_answer
    answers.best_one
  end
end
