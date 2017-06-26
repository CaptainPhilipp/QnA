require 'rails_helper'

RSpec.describe QuestionPolicy do
  subject { described_class.new(user, record) }

  assign_users

  context 'For guest' do
    let(:user) { nil }
    let(:record) { create :question, user: other_user }

    it { should allow :index }
    it { should allow :show }
    it { should_not allow :new }
    it { should_not allow :create }
    it { should_not allow :edit }
    it { should_not allow :update }
    it { should_not allow :destroy }
  end

  context 'For any user' do
    let(:record) { create :question, user: other_user }

    it { should allow :index }
    it { should allow :show }
    it { should allow :new }
    it { should allow :create }
    it { should_not allow :edit }
    it { should_not allow :update }
    it { should_not allow :destroy }
    it { should allow :vote }
  end

  context 'For owner' do
    let(:record) { create :question, user: user }

    it { should allow :index }
    it { should allow :show }
    it { should allow :new }
    it { should allow :create }
    it { should allow :edit }
    it { should allow :update }
    it { should allow :destroy }
    it { should_not allow :vote }
  end
end
