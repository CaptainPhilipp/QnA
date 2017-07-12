class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?    ; true                end
  def show?     ; true                end
  def create?   ; user_confirmed?     end
  def new?      ; create?             end
  def update?   ; user_owns_entity?   end
  def edit?     ; update?             end
  def destroy?  ; user_owns_entity?   end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  protected

  def user_owns_entity?
    user && record && record.user_id == user.id
  end

  def user_confirmed?
    user && user.confirmed?
  end
end
