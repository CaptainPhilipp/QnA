require 'rails_helper'

RSpec.describe Voice, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:rateable) }
  it { have_db_column :value }
  it do
    should validate_numericality_of(:value)
      .is_less_than_or_equal_to(1)
      .is_greater_than_or_equal_to(-1)
  end
end
