require "rails_helper"

RSpec.describe InstantMailer, type: :mailer do
  describe "#notify_about_answer" do
    assign_user
    let(:question) { create :question, user: user }
    let(:subscriptions) { create_list :subscription, 3, question: question }
    let(:other_subscription) { create :subscription }
    let!(:subscriber_emails) { subscriptions.map { |s| s.user.email } }

    let(:answer) { create :answer, question: question }
    let(:mail) { InstantMailer.notify_about_answer(answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New answer to your question')
      expect(mail.to).to eq(subscriber_emails)
      expect(mail.to).to_not include(other_subscription.email)
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'mail have answer' do
      expect(mail.body.encoded).to have_content(answer.body)
    end

    it 'mail have question title' do
      expect(mail.body.encoded).to have_content(question.title)
    end
  end
end