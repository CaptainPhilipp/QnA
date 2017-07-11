require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:users)     { create_list :user, 3 }
  let!(:questions) { create_list(:question, 3) }

  it 'sends mail with digest to each user' do
    User.find_each do |user|
      expect(DailyMailer).to receive(:digest).with(user, questions).and_call_original
    end

    DailyDigestJob.perform_now
  end
end
