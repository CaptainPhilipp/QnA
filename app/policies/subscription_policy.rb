class SubscriptionPolicy < ApplicationPolicy
  def create?
    user_confirmed?
  end

  def destroy?
    create?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
