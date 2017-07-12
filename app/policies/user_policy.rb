# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def me?
    user == record
  end

  def index?
    user_confirmed?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
