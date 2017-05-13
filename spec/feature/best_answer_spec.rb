require_relative 'acceptance_helper'

feature 'Best answer to question', '
    In order to appreciate more usefull answer,
    Question owner can mark some answer as best.
  ' do

  assign_users :user, :other_user

  let(:question) { create :question, user: user }
  let(:answers)  { create_list :answer, 5, question: question }

  let(:set_best_answer)  { question.best_answer = answers.sample }
  let(:link_set_best_answer) { I18n.t :set_best_answer, scope: 'question.show' }

  context 'When owner,' do
    login_user

    context "and when best answer isn't setted," do
      scenario do
        expect(page).to_not have_selector '#best_answer'
      end

      scenario 'User can set answer as best'
    end

    context 'and when best answer is already setted,' do
      scenario do
        expect(question.best_answer).to_not be nil
        expect(page).to have_selector '#best_answer'
      end

      scenario 'User can replace best answer flag'
    end
  end

  context 'When not owner,' do
    login_user :other_user

    scenario "User can't see link" do
      expect(page).to_not have_content link_set_best_answer
    end

    scenario 'User can see best answer' do
      set_best_answer
      expect(page).to have_selector '#best_answer'
    end
  end
end
