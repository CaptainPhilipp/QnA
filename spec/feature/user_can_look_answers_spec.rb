require 'rails_helper'

feature 'Guest can look all answers on question page' do
  scenario do
    question = create :question, user: create(:user)
    answers = create_list :answer, 5, question: question, user: create(:user)

    visit question_path(question)
    # TODO: each
    5.times { |i| expect(page).to have_content answers[i].body }
  end
end
