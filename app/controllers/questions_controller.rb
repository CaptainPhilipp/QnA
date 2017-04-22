class QuestionsController < ApplicationController
  before_action :load_question, only: %i(show edit update destroy)

  def index
    @questions = Question.all
  end

  def create
    @question = Question.new(questions_params)
    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def show
    @question = Question.find(params[:id])
    @answers  = @question.answers
  end

  def new
    @question = Question.new
  end

  def edit; end

  def update
    if @question.update(questions_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_url
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit %i(title body)
  end
end
