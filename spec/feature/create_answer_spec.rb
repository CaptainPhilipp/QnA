require 'rails_helper'

feature 'create answer', %q(
    In order to get answer from community,
    User can ask the question
  ) do

  let(:user) { create :user }
  let(:question) { create :question, user: user }

  scenario 'new answer form must exist' do
    log_in(user)
    visit question_path(question)
    expect(page).to have_content Answer.human_attribute_name(:body)
  end

  let(:answer_body) { 'Great answer' }
  let(:user) { create :user }

  scenario 'with valid answer' do
    log_in(user)
    visit question_path(question)
    fill_in Answer.human_attribute_name(:body), with: answer_body
    click_on I18n.t(:create, scope: 'answers.form')
    expect(page).to have_content(answer_body)
  end

  scenario "not authorized user can't create answer" do
    visit question_path(question)
    expect(page).to_not have_content Answer.human_attribute_name(:body)
    expect(page).to     have_content I18n.t(:authentication_required, scope: 'answers.form')
  end
end
