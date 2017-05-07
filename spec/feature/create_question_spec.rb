require 'rails_helper'

feature 'create question', %q(
    In order to get answer from community,
    User can ask the question
  ) do

  let(:question) { { title: 'Question title', body: 'Question body' } }

  context 'when authorized' do
    before do
      visit new_user_session_path
      fill_log_in(create :user)
    end

    scenario 'user can open and create_question page from questions page' do
      visit questions_path
      click_link I18n.t(:create, scope: 'questions.index')
      expect(current_path).to eq new_question_path
    end

    scenario 'after create, user can see his question' do
      visit new_question_path
      create_question_with_form
      expect(page).to have_content question[:title]
      expect(page).to have_content question[:body]
    end
  end

  context 'when not authorized' do
    scenario "user can't ask a question" do
      visit new_question_path
      expect(page).to_not have_content Question.human_attribute_name(:body)
      expect(page).to     have_content 'Log in'
    end
  end
end
