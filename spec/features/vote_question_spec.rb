# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'User can change rating of answes', '
    In order to rate an question,
    User can vote for question of other user
  ' do

  assign_users :user, :other_user

  let!(:question) { create :question, user: user }

  let(:question_selector) { "#question_#{question.id}" }

  context 'When authenticated as not owner,' do
    login_user :other_user
    before { visit questions_path }

    context 'and when question is not rated by user' do
      scenario "User don't see button for cancel voice" do
        within '#questions .body .rating' do
          expect(page).to_not have_css '.cancel_voice a'
        end
      end

      scenario 'User can rate up the question', js: true do
        within '#questions .body .rating' do
          find('i.glyphicon-chevron-up').click

          within '.score' do
            expect(page).to have_content '1'
          end

          expect(page).to have_css '.cancel_voice a'
        end
      end

      scenario 'User can rate down the question', js: true do
        within '#questions .body .rating' do
          find('i.glyphicon-chevron-down').click

          within '.score' do
            expect(page).to have_content '-1'
          end

          expect(page).to have_css '.cancel_voice a'
        end
      end
    end

    context 'and when already rated for question', js: true do
      before do
        question.vote!(1, other_user)
        page.evaluate_script('window.location.reload()')
      end

      scenario 'User see current rating', js: true do
        within '#questions .body .rating .score' do
          expect(page).to have_content '1'
        end
      end

      scenario "User don't see vote links", js: true do
        within '#questions .body .rating' do
          expect(page).to_not have_css '.change_rate a'
        end
      end

      scenario 'User can cancel his voice', js: true do
        within '#questions .body .rating' do
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
      visit questions_path
    end

    scenario 'User cant see vote links' do
      within '#questions .body .rating' do
        expect(page).to_not have_selector 'i.glyphicon-chevron-down'
        expect(page).to_not have_selector 'i.glyphicon-chevron-up'
      end
    end
  end

  context 'When not authenticated,' do
    before do
      visit questions_path
    end

    scenario 'user cant use vote inks' do
      within '#questions .body .rating' do
        find('i.glyphicon-chevron-down').click
        within('.score') { expect(page).to have_content '0' }

        find('i.glyphicon-chevron-up').click
        within('.score') { expect(page).to have_content '0' }
      end
    end
  end
end
