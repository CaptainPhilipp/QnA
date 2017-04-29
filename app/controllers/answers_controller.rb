class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question

  def create
    @answer = @question.answers.new(answers_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question
    else
      @answers = @question.answers
      render 'questions/show', id: @question.id
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body)
  end
end
