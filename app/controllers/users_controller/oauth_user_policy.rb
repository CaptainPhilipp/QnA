class OauthUserPolicy
  def initialize(user)
    @user = user
  end

  def complete?
    user.valid? && user.confirmed?
  end

  def unconfirmed?
    user.valid? && !user.confirmed?
  end

  def email_taken?
    email_errors.any? && email_errors.first[:error] == :taken
  end

  private

  attr_reader :user

  def email_errors
    @email_errors ||= user.errors.details[:email]
  end
end
