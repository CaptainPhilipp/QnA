class AnswersController < ApplicationController
  include Rated

  before_action :authorize_answers, only: %i(create)
  before_action :load_and_authorize_answer, only: %i(update destroy best)
  before_action :load_question, only: %i(create)

  after_action :broadcast_answer, only: [:create]
  after_action :notify_question_subscribers, only: [:create]
  after_action :verify_authorized

  respond_to :html, :js

  def create
    respond_with(@answer = @question.answers.create(answers_params.merge user: current_user))
  end

  def update
    respond_with(@answer.update(answers_params))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def best
    @answer.best!
  end

  private

  def authorize_answers
    authorize Answer
  end

  def load_and_authorize_answer
    authorize @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def broadcast_answer
    return if @answer.errors.any?
    AnswersChannel.broadcast_to @question, AnswersSerializer.new(@answer).to_json
  end

  def notify_question_subscribers
    return if @answer.errors.any?
    InstantMailer.delay.notify_about_answer(@answer)
  end

  def answers_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def unauthorized_respond_to(format, exception)
    format.html do
      redirect_to current_user ? users_path : new_user_session_path, notice: exception
    end

    super
  end
end
