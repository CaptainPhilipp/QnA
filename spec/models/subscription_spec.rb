require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }

  assign_users

  describe '.subscribe_author(question)' do
    let!(:question) { create :question, user: user }

    it 'creates subscription' do
      expect { Subscription.subscribe_author question }.to change(Subscription, :count).by(1)
    end

    it 'created subscription have right user and question' do
      Subscription.subscribe_author(question)
      expect(Subscription.last.user).to eq user
      expect(Subscription.last.question).to eq question
    end
  end
end
