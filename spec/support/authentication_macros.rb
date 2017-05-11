module AuthenticationMacros
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module InstanceMethods
    def login_user(user)
      visit new_user_session_path
      fill_login_user(user)
    end

    def fill_login_user(user)
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end
  end

  module ClassMethods
    def login_user
      let(:user) { create :user }
      before { login_user(user) }
    end

    def login_other_user
      let(:other_user) { create :user }
      before { login_user(other_user) }
    end
  end
end
