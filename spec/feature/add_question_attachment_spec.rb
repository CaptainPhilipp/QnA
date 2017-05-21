require_relative 'acceptance_helper'

feature 'Attach files to question', "
    In order to illustrate my answer
    As an answer's author
    I'd like to be able to attach files
  " do

  let(:attributes) { attributes_for :question }
  let(:file_field_name) { Attachment.human_attribute_name(:file) }
  let(:model_name) { I18n.t(:question, scope: 'activerecord.models', count: 1) }

  login_user
  background { visit new_question_path }

  scenario 'User adds a few files to question', js: true do
    fill_in Question.human_attribute_name(:title), with: attributes[:title]
    fill_in Question.human_attribute_name(:body),  with: attributes[:body]
    4.times { click_link Attachment.human_attribute_name(:add) }

    all('form .nested-fields').each_with_index do |a, i|
      within(a) { attach_file file_field_name, "#{Rails.root}/spec/upload_fixtures/#{i + 1}_test.rb" }
    end

    click_button I18n.t(:create, scope: 'helpers.submit', model: model_name)

    within('.question-body .files') do
      Question.last.attachments.each do |a|
        expect(page).to have_link a.file.identifier, href: a.file.url
      end
    end
  end
end
