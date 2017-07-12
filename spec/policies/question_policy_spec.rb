# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionPolicy do
  subject { described_class.new(user, record) }

  assign_users

  context 'For guest' do
    let(:user) { nil }
    let(:record) { create :question, user: other_user }

    it { should     allow :index, :show }
    it { should_not allow :new, :create }
    it { should_not allow :edit, :update, :destroy }
  end

  context 'For any user' do
    let(:record) { create :question, user: other_user }

    it { should     allow :index, :show }
    it { should     allow :new, :create }
    it { should_not allow :edit, :update, :destroy }
    it { should     allow :vote }
  end

  context 'For owner' do
    let(:record) { create :question, user: user }

    it { should     allow :index, :show }
    it { should     allow :new, :create }
    it { should     allow :edit, :update, :destroy }
    it { should_not allow :vote }
  end
end
