require_relative 'acceptance_helper'

feature 'Attach files to question', "
    In order to illustrate my answer
    As an answer's author
    I'd like to be able to attach files
  " do

  let(:attributes) { attributes_for :question }
  let(:file_field_name) { Attachment.human_attribute_name(:file) }

  login_user
  background { visit new_question_path }

  scenario 'User adds file to question', js: true do
    within 'form#new_question' do
      fill_in Question.human_attribute_name(:title), with: attributes[:title]
      fill_in Question.human_attribute_name(:body),  with: attributes[:body]
      click_link Attachment.human_attribute_name(:add)

      attach_file file_field_name, "#{Rails.root}/spec/rails_helper.rb"

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
    4.times { click_link Attachment.human_attribute_name(:add) }

    all('form .nested-fields').each_with_index do |a, i|
      within(a) { attach_file file_field_name, "#{Rails.root}/spec/uploads/#{i + 1}_test.rb" }
    end

    click_button I18n.t(:create, scope: 'questions.form')

    within('.question-body .files') do
      Question.last.attachments.each do |a|
        expect(page).to have_link a.file.identifier, href: a.file.url
      end
    end
  end
end
