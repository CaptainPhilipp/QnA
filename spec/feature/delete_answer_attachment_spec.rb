require_relative 'acceptance_helper'

feature 'Attach files to answer', "
    In order to illustrate my answer
    As an answer's author
    I'd like to be able to attach files
  " do

  login_user
  let(:question)    { create :question }
  let!(:answer)     { create :answer, question: question, user: user }
  let!(:attachment) { create :attachment, attachable: answer }

  let(:file_field_name) { Attachment.human_attribute_name(:file) }
  let(:attributes) { attributes_for :answer }

  background { visit question_path(question) }

  scenario 'User deletes attachments', js: true do
    within "#answer_#{answer.id}" do
      click_on I18n.t(:edit)
      click_link Attachment.human_attribute_name(:delete)
      click_on I18n.t(:save)

      wait_for_ajax
      expect(page).to_not have_link attachment.file.identifier, href: attachment.file.url
    end
  end
end
