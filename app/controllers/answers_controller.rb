class AnswersController < ApplicationController
  def index
    @answers = Answer.where question_id: params[:question_id]
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answers_params)
    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  def edit
  end

  private

  def answers_params
    params.require(:answer).permit(:body)
      .merge(question_id: params[:question_id])
  end
end
