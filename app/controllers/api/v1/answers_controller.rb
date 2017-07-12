# frozen_string_literal: true

module Api::V1
  class AnswersController < BaseController
    before_action :load_question, only: [:create]

    def show
      authorize @answer = Answer.find(params[:id])
      respond_with @answer
    end

    def create
      authorize Answer
      respond_with @answer = @question.answers.create(personalized_answer_params)
    end

    private

    def personalized_answer_params
      answer_params.merge user: current_resource_owner
    end

    def answer_params
      params.permit(:body)
    end

    def load_question
      @question = Question.find(params[:question_id])
    end
  end
end
