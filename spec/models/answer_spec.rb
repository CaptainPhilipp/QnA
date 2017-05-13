require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }

  it { should belong_to(:question) }

  it { should validate_length_of(:body).is_at_least(6) }

  let(:question) { create :question }
  let(:answer) { create :answer, question: question }
  let(:other_answer) { create :answer, question: question }

  context '#best_answer?' do
    it 'should be false if question have no best answer' do
      expect(question.best_answer).to be nil
      expect(answer.best_answer?).to be false
    end

    it 'should be false if other answer are best' do
      question.update best_answer: other_answer
      expect(answer.reload.best_answer?).to be false
    end

    it 'should be true if it is best answer' do
      question.update best_answer: answer
      expect(answer.reload.best_answer?).to be false
    end
  end
end
