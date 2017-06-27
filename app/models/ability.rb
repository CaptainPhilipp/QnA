class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, :all

    if user.persisted?
      can :create, managable_models
      can [:update, :destroy], managable_models, user_id: user.id
      can :vote, [Question, Answer] do |record|
        record.user_id != user.id
      end
      can :best, Answer, question: { user_id: user.id }
    end
  end

  private

  def managable_models
    [Question, Answer, Comment]
  end

  attr_reader :user
end
