class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(email)

  def email
    @user = OauthUserAuthorization.from_session(auth_params, session)
    if @user.valid? && @user.confirmed?
      sign_in_and_redirect(user, event: :authorization)
    elsif @user.errors.details[:email].first[:error] == :taken
      flash[:warning] = 'User with this email already registered. Please try to login'
      flash[:notice] = 'User with this email already registered. Please try to login'
      redirect_to new_user_session_path
    else
      render('email')
    end
  end

  private

  def auth_params
    params.permit(:email)
  end
end
