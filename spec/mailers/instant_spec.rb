# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InstantMailer, type: :mailer do
  describe '#notify_about_answer' do
    assign_user
    let(:question) { create :question, user: user }

    let(:answer) { create :answer, question: question }
    let(:mail) { InstantMailer.notify_about_answer(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New answer to your question')
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'mail have answer' do
      expect(mail.body.encoded).to have_content(answer.body)
    end

    it 'mail have question title' do
      expect(mail.body.encoded).to have_content(question.title)
    end

    it 'mail have unsubscribe link' do
      expect(mail.body.encoded).to have_link('Unsubscribe from new answers')
    end
  end
end
