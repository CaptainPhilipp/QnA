class AnswersController < ApplicationController
  include Rated

  before_action :load_answer,   only: %i(update destroy best)
  before_action :load_question, only: %i(create)
  before_action :check_owner!,  only: %i(update destroy)
  after_action :broadcast_answer, only: [:create]

  def create
    @answer = @question.answers.new(answers_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answers_params)
  end

  def destroy
    @answer.destroy
    respond_to do |format|
      format.js { render 'destroy' }
      format.html { redirect_to @answer.question }
    end
  end

  def best
    # TODO: сделать нормальный ответ в случае отказа
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
    ActionCable.server.broadcast "question/#{@question.id}/answers", ApplicationController.render(@answer)
    # AnswersChannel.broadcast_to @question, ApplicationController.render(@answer)
  end

  def answers_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
