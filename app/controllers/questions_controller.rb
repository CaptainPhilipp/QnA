class QuestionsController < ApplicationController
  include PublicRead
  include HasAssignedEntity
  include Rated

  before_action :assign_entity, only: %i(show edit update destroy)
  before_action :check_owner!, only: %i(edit update destroy)

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

  def check_owner!
    redirect_to @question unless current_user.owner? @question
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
