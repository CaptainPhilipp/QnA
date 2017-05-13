class AddBestAnswerRelationToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :best_answer
    add_foreign_key :questions, :answers, column: :best_answer_id
  end
end
