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

  scenario 'User adds file to question', js: true do
    within 'form#new_question' do
      fill_in Question.human_attribute_name(:title), with: attributes[:title]
      fill_in Question.human_attribute_name(:body),  with: attributes[:body]
      click_link Attachment.human_attribute_name(:add)
      wait_for_ajax

      attach_file Attachment.human_attribute_name(:file),
        "#{Rails.root}/spec/rails_helper.rb"

      click_button I18n.t(:create, scope: 'questions.form')
    end

    within '.question-body .files' do
      attachment = Question.last.attachments.last
      expect(page).to have_link attachment.file.identifier, href: attachment.file.url
    end
  end

  scenario 'User adds a few files to question', js: true do
    fill_in Question.human_attribute_name(:title), with: attributes[:title]
    fill_in Question.human_attribute_name(:body),  with: attributes[:body]

    (0..3).each do |i|
      click_link Attachment.human_attribute_name(:add)
    end

    all('form .nested-fields').each_with_index do |a, i|
      within a do
        attach_file Attachment.human_attribute_name(:file),
          "#{Rails.root}/spec/uploads/#{i}_test.rb"
      end
    end

    click_button I18n.t(:create, scope: 'questions.form')

    within('.question-body .files') do
      Question.last.attachments.each do |a|
        expect(page).to have_link a.file.identifier, href: a.file.url
      end
    end
  end

  scenario 'User deletes a file from question', js: true
end
