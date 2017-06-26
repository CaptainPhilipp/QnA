class QuestionsController < ApplicationController
  include Rated

  authorize_resource

  skip_before_action :authenticate_user!, only: %i(index show)

  before_action :load_question, only: %i(show edit update destroy)
  before_action :check_owner!,  only: %i(destroy)
  after_action :broadcast_question, only: [:create]

  respond_to :html, :js

  def index
    # authorize! :read, Question
    respond_with(@questions = Question.all)
  end

  def create
    # authorize! :create, Question
    respond_with(@question = current_user.questions.create(questions_params))
  end

  def show
    @answer = Answer.new
    # authorize! :show, Question
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

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to question_path(params[:id])
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
