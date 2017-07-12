# frozen_string_literal: true

class AnswerNotifyJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.includes(:user).each do |subscription|
      InstantMailer.notify_about_answer(subscription.user, answer).deliver_later
    end
  end
end
