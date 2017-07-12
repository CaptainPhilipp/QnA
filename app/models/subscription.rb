# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :user

  def self.subscribe_author(question)
    create question: question, user: question.user
  end
end
