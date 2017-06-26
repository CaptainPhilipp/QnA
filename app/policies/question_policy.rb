class QuestionPolicy < ApplicationPolicy
  def vote?
    user && record.user_id != user.id
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
