class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, length: { minimum: 6 }

  def self.persisted
    select(&:persisted?)
  end
end
