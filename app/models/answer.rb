class Answer < ApplicationRecord
  belongs_to :question

  validates :body, length: { minimum: 6 }
end
