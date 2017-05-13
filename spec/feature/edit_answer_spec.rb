# require_relative 'acceptance_helper'
#
# feature 'Edit answer', %q(
#     In order to correct his answer,
#     User can edit answer
#   ) do
#
#   assign_users
#   let(:question) { create :question }
#   let!(:answer)  { create :answer, question: question, user: user }
#   let(:attributes)     { attributes_for :answer }
#   let(:new_attributes) { attributes_for :new_answer }
#
#
#   context 'when user is owner' do
#     login_user
#
#     scenario "can edit his answer", js: true do
#       visit question_path(question)
#       within "#answers" do
#         click_on I18n.t :edit
#         save_and_open_page
#         expect_standart_form(Answer, factory: :new_answer, link: I18n.t(:save), fields: [:body])
#       end
#       expect(page).to_not have_content attributes[:body]
#     end
#   end
#
#   context "when user is not owner" do
#     login_user :other_user
#
#     scenario "can't see edit answer link" do
#       visit question_path(question)
#       within '#answers' do
#         expect(page).to_not have_link I18n.t :edit
#       end
#     end
#   end
# end
