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
      let(:user) { create :user }
      before { login_user user }
    end

    def login_other_user
      let(:other_user) { create :user }
      before { login_user other_user }
    end
  end
end
