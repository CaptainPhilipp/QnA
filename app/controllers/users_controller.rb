class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(email)

  def email
    @user = OauthUserService.from_session(auth_params, session)

    if @user.valid? && @user.confirmed?
      sign_in_and_redirect(user, event: :authorization)

    elsif @user.email_taken_error?
      when_email_taken

    elsif @user.valid? && !@user.confirmed?
      when_successful_registered
    else
      render('email')
    end
  end

  private

  def when_email_taken
    flash[:notice] = 'User with this email already registered. Please try to login'
    redirect_to new_user_session_path
  end

  def when_successful_registered
    flash[:notice] = 'User registered! Please, confirm email'
    redirect_to new_user_session_path
  end

  def auth_params
    params.permit(:email)
  end
end
