class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authorize, only: %i(facebook twitter)

  def facebook
  end

  def twitter
  end

  private

  def authorize
    service = OauthUserService.new(request.env['omniauth.auth'])
    @user = service.get_user
    if @user.valid?
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
      sign_in_and_redirect(@user, event: :authorization)
    else
      service.save_auth_to(session)
      render('users/email')
    end
  end

  def provider
    @provider ||= request.env['omniauth.auth'].provider.classify
  end

  def auth_params
    params.permit(:email)
  end
end
