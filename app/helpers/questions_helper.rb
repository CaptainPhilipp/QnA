module QuestionsHelper
  def subscribed?
    Subscription.where(user: current_user, question: @question).limit(1).count.positive?
  end
end
