require_relative 'acceptance_helper'

feature 'Login with remote provider' do
  let(:twitter_signin_link) { 'Sign in with Twitter' }
  let(:facebook_signin_link) { 'Sign in with Facebook' }
  let(:enter_email_message) { 'Please enter your email for complete registration' }

  let(:email) { 'test@example.com' }

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
    xscenario 'User enters email' do
     mock_auth_without_email
     click_link twitter_signin_link

     expect(page).to have_content enter_email_message
     fill_in 'email', with: email
     click_button 'Save'

     visit email_trigger_path
     open_email(email)
     click_link 'Confirm my account'

     expect(page).to have_content 'User registered! Please, confirm email'
    end

    scenario 'User leaves email field empty' do
     mock_auth_without_email
     click_link twitter_signin_link

     expect(page).to have_content enter_email_message
     fill_in 'email', with: ''
     click_button 'Save'
     expect(page).to have_content enter_email_message
    end
  end
end
