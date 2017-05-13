require_relative 'acceptance_helper'

feature 'Best answer to question', '
    In order to appreciate more usefull answer,
    Question owner can mark some answer as best.
  ' do

  assign_users :user, :other_user

  let(:question) { create :question, user: user }
  let!(:answers)  { create_list :answer, 5, question: question }
  let(:answer)   { answers.sample }

  let(:div_answer_id) { "#answer_#{answer.id}" }
  let(:link_set_best_answer) { Question.human_attribute_name(:best_answer) }

  context 'When owner,' do
    login_user
    before { visit question_path(question) }

    context "and when best answer isn't setted," do
      scenario 'shound not present any best answer' do
        expect(question.best_answer).to be nil
        expect(page).to_not have_selector '.best_answer'
      end

      scenario 'User sets answer as best', js: true do
        within div_answer_id do
          click_link link_set_best_answer
          save_and_open_page
          expect(page).to have_selector '.best_answer'
          expect(page).to have_selector "#{div_answer_id}.best_answer"
        end
      end
    end

    context 'and when best answer is already setted,' do
      before { question.update best_answer: answer }

      scenario 'it is must be present' do
        expect(question.best_answer).to be answer

        within div_answer_id do
          expect(page).to have_selector '.best_answer'
        end
      end

      scenario 'User can replace best answer flag' do
        within div_answer_id do
          click_link link_set_best_answer
          expect(page).to have_selector '.best_answer'
          expect(page).to have_selector "#{div_answer_id}.best_answer"
        end
      end
    end
  end

  context 'When not owner,' do
    login_user :other_user

    scenario "User can't see link" do
      expect(page).to_not have_content link_set_best_answer
    end

    scenario 'User can see best answer' do
      question.update best_answer: answers.sample
      expect(page).to have_selector '.best_answer'
    end
  end
end
