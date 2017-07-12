# frozen_string_literal: true

class AnswerPolicy < ApplicationPolicy
  def best?
    user && record.question.user_id == user.id
  end

  def vote?
    user && record.user_id != user.id
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
