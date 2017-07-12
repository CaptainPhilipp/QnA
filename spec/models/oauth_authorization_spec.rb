# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthAuthorization, type: :model do
  it { should belong_to :user }
  it { should have_db_column :provider }
  it { should have_db_column :uid }
end
