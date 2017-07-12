# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authorize, only: %i[facebook twitter]

  def facebook; end

  def twitter; end

  private

  def authorize
    service = OauthUserService.new(provider: auth.provider, uid: auth.uid, info: auth.info)
    @user = service.get_user
    if @user.valid?
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
      sign_in_and_redirect(@user, event: :authorization)
    else
      session['devise.oauth_authorization'] = service.get_auth.id
      render('users/email')
    end
  end

  def provider
    @provider ||= auth.provider.classify
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end

  def auth_params
    params.permit(:email)
  end
end
