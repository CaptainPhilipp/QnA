require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments) }

  it { have_db_column :best }

  it { should validate_length_of(:body).is_at_least(6) }

  let(:question) { create :question }
  let(:answer) { create :answer, question: question }
  let(:best_answer) { create :answer, question: question, best: true }

  context '#best!' do
    it 'should make answer best' do
      answer.best!
      expect(answer).to be_best
    end

    it 'other answers of this question should not be best' do
      best_answer
      answer.best!
      expect(Answer.where(question: question, best: true).count).to eq 1
      expect(best_answer.reload).to_not be_best
    end
  end
end
