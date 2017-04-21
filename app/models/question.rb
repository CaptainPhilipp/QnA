class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, :body, length: { minimum: 6 }
end
