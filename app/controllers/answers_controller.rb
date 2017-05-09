class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer,   only: :destroy
  before_action :check_answer_ownership!, only: :destroy

  def create
    @answer = @question.answers.new(answers_params)
    @answer.user = current_user
    render @answer.save ? 'create' : 'errors'
  end

  def destroy
    @answer.destroy
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
    redirect_to answer_path(@answer) unless current_user.owner? @answer
  end
end
