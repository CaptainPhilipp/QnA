module ControllerMacros
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module InstanceMethods
    def login_user(user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end
  end

  module ClassMethods
    def login_user
      assign_user
      before { login_user user }
    end

    def login_other_user
      assign_other_user
      before { login_user other_user }
    end
  end
end
