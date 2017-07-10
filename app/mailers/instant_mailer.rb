class InstantMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.instant_mailer.notify_about_answer.subject
  #
  def notify_about_answer(answer)
    @answer   = answer
    @question = answer.question
    @subscription = answer.question
    emails = @question.subscriptions.emails

    mail to: emails, subject: 'New answer to your question' if emails.any?
  end
end
