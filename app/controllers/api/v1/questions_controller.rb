module Api::V1
  class QuestionsController < BaseController
    def index
      authorize @questions = Question.all
      respond_with @questions, each_serializer: QuestionsSerializer
    end

    def show
      authorize @question = Question.find(params[:id])
      respond_with @question
    end

    def create
      authorize Question
      respond_with @question = Question.create(personalized_question_params)
    end

    private

    def personalized_question_params
      question_params.merge user: current_resource_owner
    end

    def question_params
      params.permit(:title, :body)
    end
  end
end
