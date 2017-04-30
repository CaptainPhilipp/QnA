require 'rails_helper'

feature 'create answer', %q(
    In order to get answer from community,
    User can ask the question
  ) do

  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:answer_body) { attributes_for(:answer)[:body] }
  let(:user) { create :user }

  context 'when authorized' do
    before { log_in(user) }

    scenario 'new answer form must exist' do
      visit question_path(question)
      expect(page).to have_content Answer.human_attribute_name(:body)
    end

    scenario 'with valid answer' do
      visit question_path(question)
      fill_in Answer.human_attribute_name(:body), with: answer_body
      click_on I18n.t(:create, scope: 'answers.form')
      expect(page).to have_content(answer_body)
    end

    scenario 'with invalid answer'
  end

  scenario "not authorized user can't create answer" do
    visit question_path(question)
    expect(page).to_not have_content Answer.human_attribute_name(:body)
    expect(page).to     have_content I18n.t(:authentication_required, scope: 'answers.form')
  end
end
