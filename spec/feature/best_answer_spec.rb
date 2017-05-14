require_relative 'acceptance_helper'

feature 'Best answer to question', '
    In order to appreciate more usefull answer,
    Question owner can mark some answer as best.
  ' do

  assign_users :user, :other_user

  let(:question) { create :question, user: user }
  let!(:answers) { create_list :answer, 5, question: question }
  let(:answer)   { answers.sample }
  let(:other_answer) do
    arr_ = answers.to_a
    arr_.delete(answer)
    arr_.sample
  end

  let(:other_answer_block) { "#answer_#{other_answer.id}" }
  let(:answer_block) { "#answer_#{answer.id}" }
  let(:best_answer_link) { Answer.human_attribute_name(:best) }

  context 'When owner,' do
    login_user
    before { visit question_path(question) }

    context "and when best answer isn't setted," do
      scenario 'shound not present any best answer' do
        expect(question.best_answer).to be nil
        expect(page).to_not have_selector '.best_answer'
      end

      scenario 'User sets answer as best', js: true do
        within answer_block do
          expect(page).to have_selector '.best_answer_link'
          click_link best_answer_link
          expect(page).to_not have_selector '.best_answer_link'
        end
        expect(page).to have_selector "#{answer_block}.best_answer"
      end
    end

    context 'and when best answer is already setted,' do
      before do
        other_answer.best!
        visit question_path(question)
      end

      scenario 'it is must be present', js: true do
        within "#{other_answer_block}.best_answer" do
          expect(page).to_not have_selector '.best_answer_link'
        end
      end

      scenario 'User can replace best answer flag', js: true do
        save_and_open_page
        within answer_block do
          click_link best_answer_link
        end

        within "#{answer_block}.best_answer" do # вместо expect сработает как надо
          expect(page).to_not have_selector '.best_answer_link'
        end
      end
    end
  end

  context 'When not owner,' do
    login_user :other_user

    scenario "User can't see link" do
      visit question_path(question)
      expect(page).to_not have_content best_answer_link
    end

    scenario 'User can see best answer' do
      answers.sample.best!
      visit question_path(question)
      expect(page).to have_selector '.best_answer'
    end
  end
end
