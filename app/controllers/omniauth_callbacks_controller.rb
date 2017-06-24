class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authorize, only: %i(facebook twitter)

  def facebook
  end

  def twitter
  end

  private

  def authorize
    @user = OauthUserService.new(request, session).get_user
    if @user.valid?
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
      sign_in_and_redirect(@user, event: :authorization)
    else
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
