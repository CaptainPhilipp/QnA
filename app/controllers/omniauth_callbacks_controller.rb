class OmniauthCallbacksController < ApplicationController
  def facebook
    @user = OauthUserAuthorization.new(request.env['omniauth.auth']).call
    set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    sign_in_and_redirect @user, event: :authorization
  end
end
