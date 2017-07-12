# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyMailer, type: :mailer do
  assign_user

  describe '#digest' do
    let(:mail) { DailyMailer.digest(user, questions) }
    let!(:questions) { create_list :question, 3 }

    it 'renders the headers' do
      expect(mail.subject).to eq('Daily digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'body have new questions' do
      questions.each do |question|
        expect(mail.body.encoded).to have_content(question.title)
      end
    end
  end
end
