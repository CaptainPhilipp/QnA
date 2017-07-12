# frozen_string_literal: true

class CommentsSerializer < ActiveModel::Serializer
  attributes :id, :body
end
