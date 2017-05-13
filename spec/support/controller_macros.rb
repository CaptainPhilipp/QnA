module ControllerMacros
  def self.included(base)
    base.include ExampleMethods
    base.extend SpecMethods
  end

  module ExampleMethods
    def login_user(user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end

    alias instance_login_user login_user
  end

  module SpecMethods
    def login_user(user_name = :user)
      assign_user user_name
      before { instance_login_user send(user_name) }
    end
  end
end
