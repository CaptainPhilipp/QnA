# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentPolicy do
  assign_user
  let(:guest) { nil }

  let(:question) { create :question, user: user }

  subject { described_class }

  permissions :create? do
    it { should     permit user, Comment }
    it { should_not permit guest, Comment }
  end
end
