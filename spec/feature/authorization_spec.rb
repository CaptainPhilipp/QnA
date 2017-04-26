require 'rails_helper'

feature 'User can registrater' do
  let(:sign_up) { I18n.t(:sign_up, scope: 'devise.links') }
  let(:user_attributes) { attributes_for :user }

  scenario 'register link must exist on main page' do
    visit root_path
    click_link sign_up
    fill_in 'Email', with: user_attributes[:email]
    fill_in 'Password', with: user_attributes[:password]
    fill_in 'Password confirmation', with: user_attributes[:password_confirmation]
    click_on 'Sign up'
    expect(page).to have_content I18n.t(:signed_up, scope: 'devise.registrations')
  end
end
