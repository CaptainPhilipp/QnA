module QuestionsHelper
  def subscribed_to?(question)
    current_user.subscriptions.where(question: question).exists?
  end
end
