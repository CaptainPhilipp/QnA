require_relative 'acceptance_helper'

feature 'Only owner can operate with his Question' do
  assign_users

  let(:question) { create :question, user: user }

  context 'Answer.' do
    let(:answer) { create :answer, user: user }
  end
end
