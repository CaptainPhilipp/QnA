module QuestionsHelper
  def subscribed_to?(question)
    current_user && current_user.subscribed_to?(question)
  end
end
