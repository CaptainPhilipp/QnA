# frozen_string_literal: true

class Comment < ApplicationRecord
  include HasDeltaAssociationUser

  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true
end
