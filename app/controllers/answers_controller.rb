class AnswersController < ApplicationController
  include Rated
  check_authorization

  before_action :load_answer,   only: %i(update destroy best)
  before_action :load_question, only: %i(create)
  authorize_resource
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
    authorize! :best, @answer
    @answer.best!
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js   { head :unauthorized, content_type: 'text/html' }
      format.json { head :unauthorized, content_type: 'text/html' }
      format.html { redirect_to new_user_session_path, notice: exception.message }
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
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
