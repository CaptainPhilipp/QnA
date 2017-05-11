module ControllerMacros
  def login_user(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  def self.login_user(user)
    before { login_user(user) }
  end
end
