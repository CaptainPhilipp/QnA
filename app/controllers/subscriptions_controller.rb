# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def create
    authorize Subscription

    Subscription.find_or_create_by subscription_arguments
    redirect_to question_path(question_id)
  end

  def destroy
    authorize subscription = Subscription.find_by(subscription_arguments)

    subscription.destroy
    redirect_to question_path(question_id)
  end

  private

  def subscription_arguments
    { question_id: question_id, user: current_user }
  end

  def question_id
    params[:question_id]
  end
end
