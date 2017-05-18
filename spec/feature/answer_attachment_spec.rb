require_relative 'acceptance_helper'

feature 'Attach files to answer', "
    In order to illustrate my answer
    As an answer's author
    I'd like to be able to attach files
  " do

  let(:attributes) { attributes_for :answer }
  let(:question)   { create :question }

  login_user

  before { visit question_path(question) }

  scenario 'User adds file to answer', js: true do
    within 'form#new_answer' do
      fill_in Answer.human_attribute_name(:body),  with: attributes[:body]

      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on I18n.t(:create, scope: 'answers.form')
    end

    within '#answers' do
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end
end
