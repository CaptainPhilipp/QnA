require_relative 'acceptance_helper'

feature 'Guest can look all answers on question page' do
  scenario do
    question = create :question, user: create(:user)
    answers = create_list :answer, 5, question: question, user: create(:user)

    visit question_path(question)
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
