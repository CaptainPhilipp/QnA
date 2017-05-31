class QuestionsController < ApplicationController
  include Rated

  skip_before_action :authenticate_user!, only: %i(index show)
  before_action :load_question, only: %i(show edit update destroy)
  before_action :check_owner!,  only: %i(edit update destroy)
  after_action :broadcast_question, only: [:create]

  def index
    @questions = Question.all
  end

  def create
    @question = current_user.questions.new(questions_params)
    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def show
    @question = Question.find(params[:id])
    @answer   = Answer.new
  end

  def new
    @question = current_user.questions.new
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

  def check_owner!
    redirect_to @question unless current_user.owner? @question
  end

  def broadcast_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions', ApplicationController.render(@question)
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
