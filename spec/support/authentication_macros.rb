module AuthenticationMacros
  def fill_log_in(user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def log_in(user)
    visit new_user_session_path
    fill_log_in(user)
  end
end