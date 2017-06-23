require_relative 'acceptance_helper'

feature 'Login with remote provider' do
  let(:twitter_signin_link) { 'Sign in with Twitter' }
  let(:facebook_signin_link) { 'Sign in with Facebook' }

  background { visit new_user_session_path }

  scenario 'User tries to sign in with Facebook' do
    mock_auth_facebook
    click_link facebook_signin_link
    expect(page).to have_content('Successfully authenticated from facebook account')
  end

  scenario 'User tries to sign in with Twitter' do
    mock_auth_twitter
    click_link twitter_signin_link
    expect(page).to have_content('Successfully authenticated from twitter account')
  end
end
