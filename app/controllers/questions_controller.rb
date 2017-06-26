class QuestionsController < ApplicationController
  include Rated
  check_authorization

  before_action :load_question, only: %i(show edit update destroy)
  before_action :authorize_questions, only: %i(index new create)
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

  rescue_from Pundit::NotAuthorizedError do |exception|
    respond_to do |format|
      format.js   { head :forbidden, content_type: 'text/html' }
      format.json { head :forbidden, content_type: 'text/html' }
      format.html do
        redirect_to params[:id] ? question_url(params[:id]) : questions_url
      end
    end
  end

  private

  def authorize_questions
    authorize Question
  end

  def load_and_authorize_question
    authorize @question = Question.find(params[:id])
  end

  def broadcast_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions', ApplicationController.render(json: @question)
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
