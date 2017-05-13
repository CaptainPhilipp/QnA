require_relative 'acceptance_helper'

feature 'Edit answer', '
    In order to correct his answer,
    User can edit answer
  ' do

  assign_users
  let(:question) { create :question }
  let!(:answer)  { create :answer, question: question, user: user }

  let(:attributes)     { attributes_for :answer }
  let(:new_attributes) { attributes_for :new_answer }

  let(:visit_question) { visit question_path(question) }

  context 'when user is owner' do
    login_user

    scenario 'can edit his answer', js: true do
      visit_question
      within "#answer_#{answer.id}" do
        click_link I18n.t :edit
        # save_and_open_page
        fill_in 'answer_body', with: new_attributes[:body]
        click_on I18n.t(:save)

        expect(page).to have_content new_attributes[:body]
      end
      expect(page).to_not have_content attributes[:body]
    end
  end

  context 'when user is not owner' do
    login_user :other_user

    scenario "can't see edit answer link" do
      visit_question
      within '#answers' do
        expect(page).to_not have_link I18n.t :edit
      end
    end
  end
end
