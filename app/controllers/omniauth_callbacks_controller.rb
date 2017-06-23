class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authorize('Facebook')
  end

  def twitter
    authorize('Twitter')
  end

  def email
    @user = OauthUserAuthorization.from_session(auth_params)
    @user.valid? ? sign_in_and_redirect(@user, event: :authorization) : render('email')
  end

  private

  def authorize(provider)
    @user = OauthUserAuthorization.new(request, session).try_get_user

    if @user.valid?
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
      sign_in_and_redirect(@user, event: :authorization)
    else
      render('email')
    end
  end

  def auth_params
    params.permit(:email)
  end
end
