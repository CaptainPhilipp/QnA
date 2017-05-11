require_relative 'acceptance_helper'

feature 'Create answer', %q(
    In order to help to community,
    User can answer to question
  ) do

  assign_user
  let(:question) { create :question, user: user }
  let(:answer_body) { attributes_for(:answer)[:body] }

  context 'when authorized' do
    login_user

    scenario 'with valid answer', js: true do
      visit question_path(question)
      fill_in Answer.human_attribute_name(:body), with: answer_body
      click_on I18n.t(:create, scope: 'answers.form')
      expect(page).to have_content(answer_body)
    end

    # scenario 'with invalid answer'
  end

  context "when not authorized" do
    scenario "can't create answer" do
      visit question_path(question)
      expect(page).to_not have_content Answer.human_attribute_name(:body)
      expect(page).to     have_content I18n.t(:authentication_required, scope: 'answers.form')
    end
  end
end
