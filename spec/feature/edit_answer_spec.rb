require_relative 'acceptance_helper'

feature 'Edit answer', %q(
    In order to correct his answer,
    User can edit answer
  ) do

  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, user: user, question: question }
  let(:old_answer_body) { answer.body }
  let(:new_answer_body) { 'Edited answer' }


  context 'when user is owner' do
    before { log_in user }

    scenario "can edit his answer" do
      visit question_path(question)
      within '.answers' do
        click_on I18n.t :edit
        fill_in Answer.human_attribute_name(:body), with: new_answer_body
        click_on I18n.t :save
        expect(page).to_not have_content old_answer_body
        expect(page).to     have_content new_answer_body
      end
    end
  end

  context "when user is not owner" do
    before { log_in other_user }

    scenario "can't see edit answer link" do
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link I18n.t :edit
      end
    end
  end
end
