# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionPolicy do
  subject { described_class.new(user, record) }

  assign_users

  context 'For guest' do
    let(:user) { nil }
    let(:record) { Subscription }

    it { should_not allow :create, :destroy }
  end

  context 'For any user' do
    let(:record) { create :subscription, user: user }

    it { should allow :create, :destroy }
  end
end
