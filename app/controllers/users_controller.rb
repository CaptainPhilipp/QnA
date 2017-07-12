# frozen_string_literal: true

class UsersController < ApplicationController
  def email
    @user  = OauthUserService.create_user_with(oauth_id, user_params)
    policy = Users::OauthPolicy.new(@user)

    if policy.just_registered? then when_successful_registered
    elsif policy.email_taken? then when_email_taken
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
