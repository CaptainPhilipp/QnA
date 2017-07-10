class SubscriptionsController < ApplicationController
  def create
    Subscription.find_or_create_by subscription_arguments
    redirect_to question_path(question_id)
  end

  def destroy
    Subscription.find_by(subscription_arguments).destroy
    redirect_to question_path(question_id)
  end

  private

  def subscription_arguments
    { question_id: question_id, user: user }
  end

  def question_id
    params[:question_id]
  end

  def user
    current_user.admin? ? params[:user_id] || current_user : current_user
  end
end
