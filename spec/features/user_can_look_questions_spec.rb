require_relative 'acceptance_helper'

feature 'Guest can look all questions' do
  scenario do
    questions = create_list :question, 5, user: create(:user)
    visit questions_path
    questions.each { |question| expect(page).to have_content question.title }
  end
end
