class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :user

  def email
    user.email
  end

  def self.emails
    all.map(&:email)
  end

  def self.subscribe_author(question)
    create question: question, user: question.user
  end
end
