# Preview all emails at http://localhost:3000/rails/mailers/instant
class InstantPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/instant/notify_about_answer
  def notify_about_answer
    InstantMailer.notify_about_answer
  end

end
