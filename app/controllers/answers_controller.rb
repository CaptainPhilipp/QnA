class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer,   only: %i(update destroy best)
  before_action :check_answer_ownership!, only: %i(update destroy)

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

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answers_params
    params.require(:answer).permit(:body)
  end

  def check_answer_ownership!
    redirect_to @answer.question unless current_user.owner? @answer
  end
end
