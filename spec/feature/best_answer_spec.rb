require_relative 'acceptance_helper'

feature 'Best answer to question', '
    In order to appreciate more usefull answer,
    Question owner can mark some answer as best.
  ' do

  assign_users :user, :other_user
  let(:visit_question) { visit question_path(question) }

  let(:question) { create :question, user: user }
  let!(:answers)  { create_list :answer, 5, question: question }
  let(:answer)   { answers.sample }

  let(:sample_answer) { "#answer_#{answer.id}" }
  let(:best_answer_link) { Question.human_attribute_name(:best_answer) }

  context 'When owner,' do
    login_user
    before { visit_question }

    context "and when best answer isn't setted," do
      scenario 'shound not present any best answer' do
        expect(question.best_answer).to be nil
        expect(page).to_not have_selector '.best_answer'
      end

      scenario 'User sets answer as best', js: true do
        within sample_answer do
          expect(page).to have_selector '.best_answer_link'
          click_link best_answer_link
          expect(page).to_not have_selector '.best_answer_link'
        end
        expect(page).to have_selector "#{sample_answer}.best_answer"
      end
    end

    context 'and when best answer is already setted,' do
      before do
        answer.best!
        visit_question
      end

      scenario 'it is must be present' do
        expect(question.best_answer).to eq answer

        within sample_answer do
          expect(page).to have_selector '.best_answer_link'
        end
      end

      scenario 'User can replace best answer flag', js: true do
        within sample_answer do
          click_link best_answer_link
        end

        within "#{sample_answer}.best_answer" do # вместо expect сработает как надо
          expect(page).to_not have_selector '.best_answer_link'
        end
      end
    end
  end

  context 'When not owner,' do
    login_user :other_user

    scenario "User can't see link" do
      visit_question
      expect(page).to_not have_content best_answer_link
    end

    scenario 'User can see best answer' do
      answers.sample.best!
      visit_question
      expect(page).to have_selector '.best_answer'
    end
  end
end
