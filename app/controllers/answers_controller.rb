class AnswersController < ApplicationController
  include Rated

  before_action :load_answer,   only: %i(update destroy best)
  before_action :load_question, only: %i(create)
  before_action :check_owner!,  only: %i(update destroy)
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
    @answer.best! if current_user.owner? @answer.question
  end

  private

  def check_owner!
    redirect_to @answer.question unless current_user.owner? @answer
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def broadcast_answer
    return if @answer.errors.any?
    AnswersChannel.broadcast_to @question,
      ApplicationController.render(json: { answer: @answer, question_owner_id: @question.user_id })
  end

  def answers_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
