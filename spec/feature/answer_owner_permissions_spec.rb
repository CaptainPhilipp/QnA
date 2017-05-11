require_relative 'acceptance_helper'

feature 'Only owner can operate with his Question' do
  let(:owner_user) { create :user }
  let(:other_user)  { create :user }

  let(:question) { create :question, user: owner_user }

  context 'Answer.' do
    let(:answer) { create :answer, user: owner_user }
  end
end
