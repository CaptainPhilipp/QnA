require_relative 'acceptance_helper'

feature 'User can registrater' do
  let(:sign_up) { I18n.t(:sign_up, scope: 'devise.links') }
  let(:user_attributes) { attributes_for :user }

  scenario 'with right auth data' do
    visit root_path
    click_link sign_up
    fill_in 'Email', with: user_attributes[:email]
    fill_in 'Password', with: user_attributes[:password]
    fill_in 'Password confirmation', with: user_attributes[:password_confirmation]
    click_on 'Sign up'
    expect(page).to have_content I18n.t(:signed_up, scope: 'devise.registrations')
  end
end

feature 'User can sign in' do
  let(:sign_in) { I18n.t(:sign_in, scope: 'devise.links') }
  assign_user

  scenario 'with right data' do
    visit root_path
    click_link sign_in
    fill_login_user(user)
    expect(page).to have_content I18n.t(:signed_in, scope: 'devise.sessions')
  end
end

feature 'User can log_out' do
  let(:log_out) { I18n.t(:log_out, scope: 'devise.links') }
  assign_user

  scenario 'with right data' do
    login_user(user)
    click_link log_out
    expect(page).to have_content I18n.t(:signed_out, scope: 'devise.sessions')
  end
end
