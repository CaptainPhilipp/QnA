module QuestionsHelper
  def subscribed_to?(question)
    return unless current_user
    current_user.subscriptions.where(question: question).exists?
  end
end
