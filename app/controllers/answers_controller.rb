class AnswersController < ApplicationController
  before_action :load_question

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answers_params)
    if @answer.save
      redirect_to @question
    else
      render :new
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