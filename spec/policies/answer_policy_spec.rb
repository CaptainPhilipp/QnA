require 'rails_helper'

RSpec.describe AnswerPolicy do
  subject { described_class }

  assign_users
  let(:guest) { nil }

  let(:question) { create :question, user: other_user }
  let(:answer)   { create :answer, user: user, question: question }

  permissions :index? do
    it { should permit guest,Answer }
    it { should permit user, Answer }
  end

  permissions :create? do
    it { expect(subject).to_not permit guest, Answer }
    it { expect(subject).to     permit user, answer }
  end

  permissions :show? do
    it { expect(subject).to     permit guest, answer }
    it { expect(subject).to     permit user, answer }
    it { expect(subject).to     permit other_user, answer }
  end

  permissions :update?, :destroy? do
    it { expect(subject).to_not permit guest, answer }
    it { expect(subject).to     permit user, answer }
    it { expect(subject).to_not permit other_user, answer }
  end

  permissions :best? do
    it { expect(subject).to_not permit guest, answer }
    it { expect(subject).to_not permit user, answer }
    it { expect(subject).to     permit other_user, answer }
  end

  permissions :vote? do
    it { expect(subject).to_not permit guest, answer }
    it { expect(subject).to_not permit user, answer }
    it { expect(subject).to     permit other_user, answer }
  end
end
