module Api::V1
  class AnswersController < BaseController
    before_action :load_question, only: [:create]

    def show
      @answer = Answer.find(params[:id])
      respond_with @answer
    end

    def create
      @answer = Answer.create(answer_params.merge question: @question, user: current_resource_owner)
      respond_with @answer
    end

    private

    def answer_params
      params.permit(:body)
    end

    def load_question
      @question = Question.find(params[:question_id])
    end
  end
end
