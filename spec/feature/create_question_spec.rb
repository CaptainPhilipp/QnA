require_relative 'acceptance_helper'

feature 'Create question', '
    In order to get answer from community,
    User can ask the question
  ' do

  let(:question)   { create :question }
  let(:attributes) { attributes_for :question }
  let(:model_name) { I18n.t(:question, scope: 'activerecord.models', count: 1) }

  context 'when authorized' do
    login_user

    scenario 'user can open and create_question page from questions page' do
      visit questions_path
      click_link I18n.t(:create, scope: 'questions.index')
      expect(current_path).to eq new_question_path
    end

    scenario 'after create, user can see his question' do
      visit new_question_path

      within 'form#new_question' do
        fill_in Question.human_attribute_name(:title), with: attributes[:title]
        fill_in Question.human_attribute_name(:body),  with: attributes[:body]
      end

      click_button I18n.t(:create, scope: 'helpers.submit', model: model_name)
      expect(page).to have_content attributes[:title]
      expect(page).to have_content attributes[:body]
    end
  end

  context 'when not authorized' do
    scenario "user can't ask a question" do
      visit new_question_path
      expect(page).to_not have_selector 'form#new_question'
      expect(page).to     have_content 'Log in'
    end
  end
end
