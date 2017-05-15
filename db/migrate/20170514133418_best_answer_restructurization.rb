class BestAnswerRestructurization < ActiveRecord::Migration[5.0]
  def up
    remove_reference :questions, :best_answer

    change_column_default :answers, :best, false
    Answer.where(best: nil).update best: false
    change_column_null :answers, :best, false
  end

  def down
    add_reference :questions, :best_answer
    add_foreign_key :questions, :answers, column: :best_answer_id
    
    change_column_default :answers, :best, from: false, to: nil
    change_column_null :answers, :best, true
  end
end
