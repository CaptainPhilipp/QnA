require 'rails_helper'

feature 'create question', %q(
    In order to get answer from community,
    User can ask the question
  ) do

  scenario 'new answer form must exist' do
    new_question_from_index
    create_question_with_form
    expect(page).to have_content Answer.human_attribute_name(:body)
  end

  let(:answer_body) { 'Great answer' }

  scenario 'with valid answer' do
    new_question_from_index
    create_question_with_form
    fill_in Answer.human_attribute_name(:body), with: answer_body
    click_on I18n.t(:create, scope: 'answers.form')
    expect(page).to have_content(answer_body)
  end
end
