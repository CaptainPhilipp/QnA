require_relative 'acceptance_helper'

feature 'Only owner can operate with his Question' do
  assign_users
  let(:question) { create :question, user: user }
  let(:delete_link_name) { I18n.t :delete }

  context 'Owner' do
    login_user
    before { visit question_path(question) }

    scenario 'can see destroy link' do
      expect(page).to have_content delete_link_name
    end

    scenario 'can destroy' do
      click_link delete_link_name
      expect(page).to_not have_content(question.title)
    end
  end

  context 'Not owner' do
    login_other_user

    scenario "can't see destroy link" do
      visit question_path(question)
      expect(page).to_not have_content delete_link_name
    end
  end
end
