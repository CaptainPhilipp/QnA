module Api::V1
  class QuestionsController < BaseController
    def index
      @questions = Question.all
      respond_with @questions, each_serializer: QuestionsSerializer
    end

    def show
      respond_with @question = Question.find(params[:id])
    end

    def create
      @question = Question.create(question_params.merge user: current_resource_owner)
      respond_with @question
    end

    private

    def question_params
      params.permit(:title, :body)
    end
  end
end
