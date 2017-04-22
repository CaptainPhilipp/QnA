class AnswersController < ApplicationController
  def new
    @answer = Answer.new(answer_question)
  end

  def create
    @answer = Answer.new(answers_params)
    if @answer.save
      redirect_to question_path(answers_params[:question_id])
    else
      render :new
    end
  end

  private

  def answers_params
    params.require(:answer).permit(:body)
      .merge answer_question
  end

  def answer_question
    { question_id: params[:question_id] }
  end
end
