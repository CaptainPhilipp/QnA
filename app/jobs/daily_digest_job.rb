class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    User.find_each { |user| DailyMailer.digest(user).deliver_later }
  end
end
