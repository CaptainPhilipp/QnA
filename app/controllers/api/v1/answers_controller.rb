module Api::V1
  class AnswersController < BaseController
    def show
      @answer = Answer.find(params[:id])
      respond_with @answer
    end

    def create
      @answer = Answer.new(answer_params)
      respond_with @answer
    end

    private

    def answer_params
      params.permit(:body)
    end
  end
end
