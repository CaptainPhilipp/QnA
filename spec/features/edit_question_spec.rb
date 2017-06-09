require_relative 'acceptance_helper'

feature 'Edit question', '
    In order to correct his question,
    User can edit it' do

  assign_users
  let(:question) { create :question, user: user }

  let(:attributes)     { attributes_for :question }
  let(:new_attributes) { attributes_for :new_question }
  let(:model_name) { I18n.t(:question, scope: 'activerecord.models', count: 1) }

  context 'when user is owner' do
    login_user

    scenario 'edit link must be presented' do
      visit question_path(question)
      expect(page).to have_link I18n.t(:edit), edit_question_path(question)
    end

    scenario 'can edit his answer', js: true do
      visit edit_question_path(question)

      within 'form.edit_question' do
        fill_in 'question_body', with: new_attributes[:body]
        click_button I18n.t(:update, scope: 'helpers.submit', model: model_name)
      end

      expect(page).to have_content new_attributes[:body]
      expect(page).to_not have_content attributes[:body]
    end
  end

  context 'when user is not owner' do
    login_user :other_user
    before { visit question_path(question) }

    scenario "can't see edit answer link" do
      within '#question' do
        expect(page).to_not have_link I18n.t :edit
      end
    end
  end
end
