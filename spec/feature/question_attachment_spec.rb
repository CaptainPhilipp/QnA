require_relative 'acceptance_helper'

feature 'Attach files to question', "
    In order to illustrate my answer
    As an answer's author
    I'd like to be able to attach files
  " do

  let(:attributes) { attributes_for :question }

  login_user

  background do
    visit new_question_path
  end

  scenario 'User adds file to question' do
    within 'form#new_question' do
      fill_in Question.human_attribute_name(:title), with: attributes[:title]
      fill_in Question.human_attribute_name(:body),  with: attributes[:body]

      attach_file 'Выбрать файл', "#{Rails.root}/spec/rails_helper.rb"
      click_on I18n.t(:create, scope: 'questions.form')
    end

    within '.question-body .files' do
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end
end
