require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  assign_users

  let(:question) { create :question, user: records_owner }
  let(:answer)   { create :answer,   user: records_owner }
  let(:comment)  { create :comment,  user: records_owner }
  let(:records)  { [question, answer, comment] }
  let(:records_owner) { user }

  context 'Guest' do
    let(:user) { nil }

    it { should     be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  context 'User can read and create' do
    it { should be_able_to [:read, :create], Question }
    it { should be_able_to [:read, :create], Answer }
    it { should be_able_to [:read, :create], Comment }
  end

  context 'When user is owner of record' do
    let(:records_owner) { user }

    it { should     be_able_to [:edit, :destroy], question }
    it { should     be_able_to [:edit, :destroy], answer }
    it { should     be_able_to [:edit, :destroy], comment }
    it { should_not be_able_to :vote, records }
  end

  context 'When user is not owner of record' do
    let(:records_owner) { other_user }

    it { should_not be_able_to [:edit, :destroy], question }
    it { should_not be_able_to [:edit, :destroy], answer }
    it { should_not be_able_to [:edit, :destroy], comment }
    it { should     be_able_to :vote, question }
    it { should     be_able_to :vote, answer }
  end
end
