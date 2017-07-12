# frozen_string_literal: true

module FeatureMacros
  def self.included(base)
    base.include ExampleMethods
    base.extend FeatureMethods
  end

  module ExampleMethods
    def login_user(user)
      visit new_user_session_path
      fill_login_user(user)
    end

    alias instance_login_user login_user

    def fill_login_user(user)
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end
  end

  module FeatureMethods
    def login_user(user = :user)
      assign_user(user)
      before { instance_login_user(send(user)) }
    end
  end
end
