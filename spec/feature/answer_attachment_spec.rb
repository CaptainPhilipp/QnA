require_relative 'acceptance_helper'

feature 'Attach files to answer', "
    In order to illustrate my answer
    As an answer's author
    I'd like to be able to attach files
  " do

  let(:attributes) { attributes_for :answer }
  let(:question)   { create :question }

  let(:file_field_name) { Attachment.human_attribute_name(:file) }

  login_user

  before { visit question_path(question) }

  scenario 'User adds file to answer', js: true do
    within 'form#new_answer' do
      fill_in Answer.human_attribute_name(:body),  with: attributes[:body]

      click_link Attachment.human_attribute_name(:add)
      wait_for_ajax

      attach_file file_field_name,
        "#{Rails.root}/spec/rails_helper.rb"
      click_on I18n.t(:create, scope: 'answers.form')
    end

    within '#answers' do
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end

  scenario 'User adds a few attachments to answer', js: true do
    within 'form#new_answer' do
      fill_in Answer.human_attribute_name(:body),  with: attributes[:body]
      (0..3).each { |i| click_link Attachment.human_attribute_name(:add) }

      all('form .nested-fields').each do |a|
        within a do
          attach_file file_field_name, "#{Rails.root}/spec/uploads/#{i}_test.rb"
        end
      end

      click_on I18n.t(:create, scope: 'answers.form')

      within '#answers' do
        Answer.last.attachments.each do |a|
          expect(page).to have_link a.file.identifier, href: a.file.url
        end
      end
    end
  end
end
