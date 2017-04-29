require 'rails_helper'

feature 'Guest can look all questions' do
  scenario do
    questions = create_list :question, 5, user: create(:user)
    visit questions_path
    5.times { |i| expect(page).to have_content questions[i].title }
  end
end
