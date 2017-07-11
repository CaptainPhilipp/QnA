class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    new_questions = Question.select(:title, :id).for_last_day.to_a

    User.find_each { |user| DailyMailer.digest(user, new_questions).deliver_later }
  end
end
