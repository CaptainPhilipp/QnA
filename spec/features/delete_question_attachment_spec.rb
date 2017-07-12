# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Delete attachments from question' do
  login_user
  let(:question)    { create :question, user: user }
  let!(:attachment) { create :attachment, attachable: question }

  let(:model_name) { I18n.t(:question, scope: 'activerecord.models', count: 1) }

  background { visit edit_question_path(question) }

  scenario 'User deletes attachment' do
    within '#question' do
      click_link Attachment.human_attribute_name(:delete)
      click_button I18n.t(:update, scope: 'helpers.submit', model: model_name)

      expect(page).to_not have_link attachment.file.identifier, href: attachment.file.url
    end
  end
end
