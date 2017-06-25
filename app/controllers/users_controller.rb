class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(email)

  def email
    @user  = OauthUserService.create_user_with(oauth_id, user_params)
    policy = OauthUserPolicy.new(@user)

    case
    when policy.unconfirmed? then when_successful_registered
    when policy.email_taken? then when_email_taken
    else render('email')
    end
  end

  private

  def oauth_id
    session['devise.oauth_authorization']
  end

  def when_successful_registered
    flash[:notice] = 'User registered! Please, confirm email'
    redirect_to new_user_session_path
  end

  def when_email_taken
    flash[:notice] = 'User with this email already registered. Please try to login'
    redirect_to new_user_session_path
  end

  def user_params
    params.permit(:email)
  end
end
