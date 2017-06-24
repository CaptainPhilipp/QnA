class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(email)

  def email
    case @user = OauthUserService.from_session(auth_params, session)
    when proc(&:valid?),  proc(&:confirmed?) then sign_in_and_redirect(user, event: :authorization)
    when proc(&:valid?), !proc(&:confirmed?) then when_successful_registered
    when proc(&:email_taken_error?)          then when_email_taken
    else render('email')
    end
  end

  private

  def when_successful_registered
    flash[:notice] = 'User registered! Please, confirm email'
    redirect_to new_user_session_path
  end

  def when_email_taken
    flash[:notice] = 'User with this email already registered. Please try to login'
    redirect_to new_user_session_path
  end

  def auth_params
    params.permit(:email)
  end
end
