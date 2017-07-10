require 'rails_helper'

RSpec.fdescribe SubscriptionPolicy do
  subject { described_class.new(user, record) }

  assign_users

  context 'For guest' do
    let(:user) { nil }
    let(:record) { Subscription }

    it { should_not allow :create, :destroy }
  end

  context 'For any user' do
    let(:record) { Subscription }

    it { should allow :create, :destroy }
  end
end