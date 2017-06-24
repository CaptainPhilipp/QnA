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

  context 'User tries to sign with Twitter without an email' do
    scenario 'User enters email' do
     mock_auth_without_email
     click_link twitter_signin_link

     expect(page).to have_content 'Twitter did not provide your email, please enter it'
     save_and_open_page
     fill_in 'email', with: 'user@testemail.com'
     click_button 'Save'
     expect(page).to have_content 'Could not authenticate you from twitter because ' \
                                  'you need to confirm email'
    end

    scenario 'User leaves email field empty' do
     mock_auth_without_email
     click_link twitter_signin_link

     expect(page).to have_content 'Twitter did not provide your email, please enter it'
     fill_in 'email', with: ''
     click_button 'Save'
     expect(page).to have_content 'Twitter did not provide your email, please enter it'
    end
  end
end
