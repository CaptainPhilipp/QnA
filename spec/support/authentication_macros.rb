module AuthenticationMacros
  def fill_log_in(user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end
end
