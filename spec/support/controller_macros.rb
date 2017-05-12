module ControllerMacros
  def self.included(base)
    base.include ExampleMethods
    base.extend SpecMethods
  end

  module ExampleMethods
    alias instance_login_user login_user

    def login_user(user = :user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end
  end

  module SpecMethods
    def login_user(user = :user)
      assign_user user
      before { instance_login_user user }
    end
  end
end
