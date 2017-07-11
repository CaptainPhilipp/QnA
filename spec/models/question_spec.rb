require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments) }

  it { should validate_length_of(:title).is_at_least(6) }
  it { should validate_length_of(:body).is_at_least(6) }

  assign_user
  let(:question) { create :question, user: user }
  let(:best_answer) { create :answer, question: question, best: true }
  let(:answers) { create_list :answer, 5, question: question }

  describe '.create' do
    it 'creates subscription for author' do
      expect(question.subscriptions.pluck(:user_id).first).to eq user.id
    end
  end

  describe '#best_answer' do
    it 'returns nil if no one answer is marked as best' do
      expect(question.best_answer).to be_nil
    end

    it 'returns best answer' do
      best_answer
      expect(question.best_answer).to eq best_answer
    end
  end
end
