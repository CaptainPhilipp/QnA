class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authorize('Facebook')
  end

  def twitter
    authorize('Twitter')
  end

  def authorize(kind)
    @user = OauthUserAuthorization.new(request.env['omniauth.auth']).call
    set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    sign_in_and_redirect @user, event: :authorization
  end
end
