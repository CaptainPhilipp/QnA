class DailyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject
  #
  def digest(user)
    @questions = Question.where('created_at > ?', Date.yesterday)
                         .where.not(user_id: user.id)

    mail to: user.email, subject: 'Daily digest' if @questions.any?
  end
end
