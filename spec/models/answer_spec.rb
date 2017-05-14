require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { have_db_column :best }

  it { should validate_length_of(:body).is_at_least(6) }

  let(:question) { create :question }
  let(:answer) { create :answer, question: question }
  let(:other_answer) { create :answer, question: question }

  context '#best?' do
    it 'should be false if other answer are best' do
      other_answer.best!
      expect(answer.reload).to_not be_best
    end

    it 'should be true if it is best answer' do
      answer.best!
      expect(answer.reload).to be_best
    end
  end

  context '#best!' do
    it 'should make answer best' do
      expect(answer).to_not be_best
      answer.best!
      expect(answer).to be_best
    end

    it 'other answers of this question should not be best' do
      other_answer.best!
      answer.best!
      expect(Answer.where(question: question, best: true).count).to eq 1
      expect(other_answer.reload).to_not be_best
    end
  end
end
