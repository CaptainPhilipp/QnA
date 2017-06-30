module Api::V1
  class QuestionsController < BaseController
    def index
      respond_with @questions = Question.all
    end

    def show
      respond_with @question = Question.find(params[:id])
    end
  end
end
