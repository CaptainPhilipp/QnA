class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, :all

    if user.persisted?
      can :create, managable_models
      can [:edit, :destroy], managable_models, user_id: user.id
      can :vote, [Question, Answer] do |rateable|
        rateable.user_id != user.id
      end
    end
  end

  private

  def managable_models
    [Question, Answer, Comment]
  end

  attr_reader :user
end
