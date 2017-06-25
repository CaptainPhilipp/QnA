class UsersController
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
      user.errors.added?(:email, :taken)
    end

    private

    attr_reader :user
  end
end
