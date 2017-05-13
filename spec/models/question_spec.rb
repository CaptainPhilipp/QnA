require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:best_answer) }

  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_length_of(:title).is_at_least(6) }
  it { should validate_length_of(:body).is_at_least(6) }
end
