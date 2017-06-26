class QuestionPolicy < ApplicationPolicy
  def create?
    user && user.confirmed?
  end

  def update?
    record.user_id == user.id
  end

  def destroy?
    record.user_id == user.id
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
