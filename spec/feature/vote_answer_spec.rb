require_relative 'acceptance_helper'

shared_examples :cant_change_voice, :js do
  scenario "can't change voice" do
    within '#answers .body .rating' do
      find('i.glyphicon-chevron-down').click
      within('.score') { expect(page).to have_content '0' }

      find('i.glyphicon-chevron-up').click
      within('.score') { expect(page).to have_content '0' }
    end
  end
end

feature 'User can change rating of answes', '
    In order to rate an answer,
    User can vote for answer of other oser
  ' do

  assign_users :user, :other_user

  let(:question) { create :question, user: user }
  let!(:answer)  { create :answer, question: question, user: user }

  context 'When authenticated as not owner,' do
    login_user :other_user
    before { visit question_path(question) }

    context 'and when answer is not rated by user' do
      scenario "User don't see button for cancel voice" do
        within '#answers .body .rating' do
          expect(page).to_not have_css '.cancel_voice a'
        end
      end

      scenario 'User can rate up the answer', js: true do
        within '#answers .body .rating' do
          find('i.glyphicon-chevron-up').click

          within '.score' do
            expect(page).to have_content '1'
          end

          expect(page).to have_css '.cancel_voice a'
        end
      end

      scenario 'User can rate down the answer', js: true do
        within '#answers .body .rating' do
          find('i.glyphicon-chevron-down').click

          within '.score' do
            expect(page).to have_content '-1'
          end

          expect(page).to have_css '.cancel_voice a'
        end
      end
    end

    context 'and when already rated for answer', js: true do
      before do
        answer.vote!(1, other_user)
        visit question_path(question)
      end

      scenario "User see current rating", js: true do
        within '#answers .body .rating .score' do
          expect(page).to have_content '1'
        end
      end

      scenario "User don't see vote links", js: true do
        within '#answers .body .rating' do
          expect(page).to_not have_css '.change_rate a'
        end
      end

      scenario "User can cancel his voice", js: true do
        within '#answers .body .rating' do
          find('i.glyphicon-retweet').click

          within '.score' do
            expect(page).to have_content '0'
          end

          expect(page).to_not have_css '.cancel_voice a'
        end
      end
    end
  end

  context 'When authenticated as owner,' do
    before do
      login_user(user)
      visit question_path(question)
    end

    scenario "can't see vote links" do
      within '#answers .body .rating' do
        expect(page).to_not have_selector 'i.glyphicon-chevron-down'
        expect(page).to_not have_selector 'i.glyphicon-chevron-up'
      end
    end
  end

  context 'When not authenticated,' do
    before do
      visit question_path(question)
    end

    scenario "can't use vote links" do
      within '#answers .body .rating' do
        find('i.glyphicon-chevron-down').click
        within('.score') { expect(page).to have_content '0' }

        find('i.glyphicon-chevron-up').click
        within('.score') { expect(page).to have_content '0' }
      end
    end
  end
end
