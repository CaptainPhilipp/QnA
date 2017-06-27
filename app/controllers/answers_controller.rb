class AnswersController < ApplicationController
  include Rated

  before_action :authorize_answers, only: %i(create)
  before_action :load_and_authorize_answer, only: %i(update destroy best)
  before_action :load_question, only: %i(create)
  after_action :broadcast_answer, only: [:create]

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

  rescue_from Pundit::NotAuthorizedError do |e|
    respond_to do |format|
      format.js   { self.status = :unauthorized }
      format.json { self.status = :unauthorized }
      format.html { redirect_to new_user_session_path }
    end
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
    AnswersChannel.broadcast_to @question,
      ApplicationController.render(json: @answer.serialize_to_broadcast)
  end

  def answers_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
