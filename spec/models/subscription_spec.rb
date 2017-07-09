require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }

  assign_users

  describe '#email' do
    let(:subscription) { create :subscription, user: user }

    it 'return users email' do
      expect(subscription.email).to eq user.email
    end
  end

  describe '.emails' do
    let(:create_other_subscriptions) { create_list :subscription, 3 }

    it 'return users email' do
      subscriptions = Subscription.all
      create_other_subscriptions
      expect(subscriptions.emails).to match_array(subscriptions.map { |s| s.user.email })
    end
  end

  describe '.subscribe_author(question)' do
    let(:question) { create :question, user: user }

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
