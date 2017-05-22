class AnswersController < ApplicationController
  include HasAssignedEntity

  before_action :assign_entity, only: %i(update destroy best)
  before_action :check_owner!, only: %i(update destroy)
  before_action :load_question, only: :create

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

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
