# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswerNotifyJob, type: :job do
  let!(:question) { create :question }
  let!(:answer)   { create :answer, question: question }
  let(:subscriptions) { answer.question.subscriptions.includes(:user) }

  before { create :subscription, question: question }

  it 'sends mail notification' do
    subscriptions.each do |subscription|
      user = subscription.user
      expect(InstantMailer).to receive(:notify_about_answer).with(user, answer).and_call_original
    end
    AnswerNotifyJob.perform_now(answer)
  end
end
