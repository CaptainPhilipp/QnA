require_relative 'acceptance_helper'

RSpec.feature "SubscribeToQuestions", type: :feature do
  assign_users
  let(:question) { create :question }
  let(:subscribe_link) { 'Subscribe to new answers' }
  let(:unsubscribe_link) { 'Unsubscribe from new answers' }
  let(:unsubscribe_url) { question_subscription_url(question) }

  context 'authorized' do
    context 'unsubscribed user' do
      login_user

      before { visit question_path(question) }

      scenario 'clicks subscribe link' do
        within '#question' do
          click_link subscribe_link
        end

        expect(page).to have_link unsubscribe_link
        expect(page).to_not have_link subscribe_link
      end
    end

    context 'subscribed user' do
      before { create :subscription, user: user, question: question }

      scenario 'clicks unsubscribe link' do
        login_user user
        visit question_path(question)

        within '#question' do
          click_link unsubscribe_link
        end

        expect(page).to_not have_link unsubscribe_link
        expect(page).to have_link subscribe_link
      end

      context 'receives mail' do
        let!(:question) { create :question, user: user }
        let(:attributes) { attributes_for(:answer) }

        before do
          Capybara.using_session(:user) do
            login_user user
          end

          Capybara.using_session(:other_user) do
            login_user other_user
            visit question_path(question)

            Sidekiq::Testing.inline! do
              fill_in Answer.human_attribute_name(:body), with: attributes[:body]
              click_button I18n.t(:create, scope: 'answers.form')
            end
          end
        end

        scenario 'with new answer' do
          open_email(user.email)
          expect(current_email).to have_content Answer.last.body
        end

        scenario 'find unsubscribe link in mail' do
          open_email(user.email)
          link = current_email.find_link unsubscribe_link

          expect(current_email).to have_link link.text
          expect(link[:href]).to eq unsubscribe_url
        end
      end

      scenario 'visit unsubscribe path' do
        login_user user
        visit unsubscribe_url

        expect(page).to have_link subscribe_link
        expect(page).to_not have_link unsubscribe_link
      end
    end
  end
end
