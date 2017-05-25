require 'rails_helper'

RSpec.describe Voice, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:rateable) }
  it { have_db_column :value }
  it do
    should validate_numericality_of(:value).in?(-1..1)
  end
end
