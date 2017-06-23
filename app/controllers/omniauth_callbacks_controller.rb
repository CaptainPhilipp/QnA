class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authorize, only: %i(facebook twitter)

  def facebook
  end

  def twitter
  end

  def email
    respond_for(@user = OauthUserAuthorization.from_session(auth_params, session))
  end

  private

  def authorize
    respond_for(@user = OauthUserAuthorization.new(request, session).try_get_user)
  end

  def respond_for(user)
    if user.valid?
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
      sign_in_and_redirect(user, event: :authorization)
    else
      render('email')
    end
  end

  def provider
    request.env['omniauth.auth'].provider.classify
  end

  def auth_params
    params.permit(:email)
  end
end
