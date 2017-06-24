class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(email)

  def email
    @user = OauthUserAuthorization.from_session(auth_params, session)
    @user.valid? ? sign_in_and_redirect(user, event: :authorization) : render('email')
  end

  private

  def auth_params
    params.permit(:email)
  end
end
