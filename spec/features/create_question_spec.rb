# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Create question', '
    In order to get answer from community,
    User can ask the question
  ' do

  let(:question)   { create :question }
  let(:attributes) { attributes_for :question }
  let(:model_name) { I18n.t(:question, scope: 'activerecord.models', count: 1) }

  context 'when authorized' do
    login_user

    scenario 'user can open and create_question page from questions page' do
      visit questions_path
      click_link I18n.t(:create, scope: 'questions.index')
      expect(current_path).to eq new_question_path
    end

    scenario 'after create, user can see his question' do
      visit new_question_path

      within 'form#new_question' do
        fill_in Question.human_attribute_name(:title), with: attributes[:title]
        fill_in Question.human_attribute_name(:body),  with: attributes[:body]
      end

      click_button I18n.t(:create, scope: 'helpers.submit', model: model_name)
      expect(page).to have_content attributes[:title]
      expect(page).to have_content attributes[:body]
    end
  end

  context 'when not authorized' do
    scenario "user can't ask a question" do
      visit new_question_path
      expect(page).to_not have_selector 'form#new_question'
      expect(page).to     have_content  'Войти'
    end
  end

  context 'with multiple sessions', :js do
    assign_user

    scenario "new question appears on another user's page" do
      Capybara.using_session('guest') { visit questions_path }

      Capybara.using_session('user') do
        login_user(user)
        visit questions_path
      end

      Capybara.using_session('user') do
        click_link I18n.t(:create, scope: 'questions.index')
        within 'form#new_question' do
          fill_in Question.human_attribute_name(:title), with: attributes[:title]
          fill_in Question.human_attribute_name(:body),  with: attributes[:body]
        end
        click_button I18n.t(:create, scope: 'helpers.submit', model: model_name)
      end

      Capybara.using_session('guest') do
        expect(page).to have_content attributes[:title]
      end
    end
  end
end
