module AuthenticationMacros
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module InstanceMethods
    def log_in(user)
      visit new_user_session_path
      fill_log_in(user)
    end

    def fill_log_in(user)
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end
  end

  module ClassMethods
    def login_user
      let(:user) { create :user }
      before { log_in user }
    end

    def login_other_user
      let(:other_user) { create :user }
      before { log_in other_user }
    end
  end
end
