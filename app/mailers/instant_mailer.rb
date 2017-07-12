class InstantMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.instant_mailer.notify_about_answer.subject
  #
  def notify_about_answer(user, answer)
    @answer   = answer
    @question = answer.question
    mail to: user.email, subject: 'New answer to your question'
  end
end
