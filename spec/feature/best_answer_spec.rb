require_relative 'acceptance_helper'

feature 'Best answer to question', '
    In order to appreciate more usefull answer,
    Question owner can mark some answer as best.
  ' do

  assign_users :user, :other_user

  let(:question) { create :question, user: user }
  let!(:answers) { create_list :answer, 2, question: question }
  let!(:answer)  { create :answer, question: question }

  let(:answer_selector) { "#answer_#{answer.id}" }
  let(:best_answer_link) { Answer.human_attribute_name(:best) }

  context 'When owner,' do
    login_user
    before { visit question_path(question) }

    context "and when best answer isn't setted," do
      scenario 'shound not present any best answer' do
        expect(page).to_not have_selector '.best_answer'
      end

      # FAILURE
      scenario 'User sets answer as best', js: true do
        within answer_selector do
          click_link best_answer_link
          # sleep 0.5
          # save_and_open_page
          # после клика селектор должен исчезнуть, но клик не дает эффекта.
          expect(page).to_not have_link best_answer_link
        end
        expect(page).to have_selector "#{answer_selector}.best_answer"
      end
    end

    context 'and when best answer is already setted,' do
      let!(:best_answer) { create :answer, question: question, best: true }

      before { visit question_path(question) }

      # PASS
      scenario 'best answer must be present, and must not have link', js: true do
        within "#answer_#{best_answer.id}.best_answer" do
          expect(page).to_not have_link best_answer_link
        end
      end

      # FAILURE
      scenario 'User can replace best answer flag', js: true do
        within answer_selector do
          click_on best_answer_link
        end
        # sleep 0.5
        # save_and_open_page
        # падает. клик по ссылке не создаёт ожидаемый эффект - добавление класса
        within "#{answer_selector}.best_answer" do
          expect(page).to_not have_link best_answer_link
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
