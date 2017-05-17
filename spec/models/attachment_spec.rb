require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should have_db_column(:file).with_options null: false }
  it { should belong_to :attachable }
end
