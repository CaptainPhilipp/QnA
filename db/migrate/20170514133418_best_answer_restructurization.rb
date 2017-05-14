class BestAnswerRestructurization < ActiveRecord::Migration[5.0]
  def change
    remove_reference :questions, :best_answer

    change_column_default :answers, :best, false
    Answer.where(best: nil).update best: false
    change_column_null :answers, :best, false
  end
end
