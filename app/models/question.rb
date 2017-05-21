class Question < ApplicationRecord
  include HasUser
  include Attachable

  # TODO: has_one :best_answer, -> { find_by best: true }, class_name: 'Answer'
  has_many :answers, dependent: :destroy

  validates :title, :body, length: { minimum: 6 }

  def best_answer
    answers.best_one
  end
end
