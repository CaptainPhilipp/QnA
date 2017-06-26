module Users
  class OauthPolicy
    def initialize(user)
      @user = user
    end

    def just_registered?
      user.persisted? && user.valid? && !user.confirmed?
    end

    def email_taken?
      user.errors.added?(:email, :taken)
    end

    private

    attr_reader :user
  end
end
