require_relative 'acceptance_helper'

feature 'Attach files to answer', "
    In order to illustrate my answer
    As an answer's author
    I'd like to be able to attach files
  " do

  let(:file_field_name) { Attachment.human_attribute_name(:file) }
  let(:attributes)      { attributes_for :answer }
  let(:question)        { create :question }

  login_user

  background { visit question_path(question) }

  scenario 'User adds a few attachments to answer', js: true do
    within 'form#new_answer' do
      fill_in Answer.human_attribute_name(:body),  with: attributes[:body]
      4.times { click_link Attachment.human_attribute_name(:add) }

      all('form .nested-fields').each_with_index do |a, i|
        within a do
          attach_file file_field_name, "#{Rails.root}/spec/upload_fixtures/#{i + 1}_test.rb"
        end
      end

      click_on I18n.t(:create, scope: 'answers.form')
    end

    within '#answers' do
      Answer.last.attachments.each do |a|
        expect(page).to have_link a.file.identifier, href: a.file.url
      end
    end
  end
end
