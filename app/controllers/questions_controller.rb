class QuestionsController < ApplicationController
  include Rated

  skip_before_action :authenticate_user!, only: %i(index show)

  before_action :load_question, only: %i(show edit update destroy)
  before_action :check_owner!,  only: %i(edit update destroy)
  after_action :broadcast_question, only: [:create]

  respond_to :html, :js

  def index
    respond_with(@questions = Question.all)
  end

  def create
    respond_with(@question = current_user.questions.create(questions_params))
  end

  def show
    @answer = Answer.new
    respond_with(@question = Question.find(params[:id]))
  end

  def new
    respond_with(@question = current_user.questions.new)
  end

  def edit; end

  def update
    @question.update(questions_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
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
    ActionCable.server.broadcast 'questions', ApplicationController.render(json: @question)
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
