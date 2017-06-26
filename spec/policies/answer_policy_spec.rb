require 'rails_helper'

RSpec.describe AnswerPolicy do

  let(:user) { User.new }

  subject { described_class }

  permissions :create?, :new? do
    it { should_not permit guest, Answer }
    it { should     permit user,  Answer }
  end

  permissions :index?, :show? do
    it { should     permit guest,      answer }
    it { should     permit user,       answer }
    it { should     permit other_user, answer }
  end

  permissions :update?, :edit?, :destroy? do
    it { should_not permit guest,      answer }
    it { should     permit user,       answer }
    it { should_not permit other_user, answer }
  end

  permissions :best? do
    it { should_not permit guest,      answer }
    it { should_not permit user,       answer }
    it { should     permit other_user, answer }
  end

  permissions :vote? do
    it { should_not permit guest,      answer }
    it { should_not permit user,       answer }
    it { should     permit other_user, answer }
  end
end
