class AddBestToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :best, :bool
    add_index :answers, [:question_id, :best]
  end
end
