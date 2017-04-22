require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should have_db_column(:question_id).with_options(null: false) }

  it { should validate_length_of(:body).is_at_least(6) }
end
