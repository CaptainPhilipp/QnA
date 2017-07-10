class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :user

  def self.emails
    all.map { |s| s.user.email }
  end

  def self.subscribe_author(question)
    create question: question, user: question.user
  end
end
