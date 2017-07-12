# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy do
  assign_users
  let(:new_user) { User.new }

  subject { described_class }

  permissions :me? do
    it { should permit user, user }
    it { should_not permit user, other_user }
  end

  permissions :index? do
    it { should permit user, User }
    it { should_not permit new_user, User }
  end
end
