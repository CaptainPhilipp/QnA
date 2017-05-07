require 'rails_helper'

feature 'Only owner can operate with his Question' do
  let(:owner_user) { create :user }
  let(:other_user)  { create :user }

  let(:question) { create :question, user: owner_user }
  let(:delete_link_name) { I18n.t :delete }

  context 'Owner' do
    before do
      log_in(owner_user)
      visit question_path(question)
    end

    scenario 'can see destroy link' do
      expect(page).to have_content delete_link_name
    end

    scenario 'can destroy' do
      click_link delete_link_name
      expect(page).to_not have_content(question.title)
    end
  end

  context 'Not owner' do
    scenario "can't see destroy link" do
      log_in(other_user)
      visit question_path(question)
      expect(page).to_not have_content delete_link_name
    end
  end
end
