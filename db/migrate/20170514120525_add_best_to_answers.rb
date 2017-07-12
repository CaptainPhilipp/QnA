# frozen_string_literal: true

class AddBestToAnswers < ActiveRecord::Migration[5.0]
  def up
    add_column :answers, :best, :bool, null: false, default: false
    add_index :answers, %i[question_id best]
  end

  def down
    remove_column :answers, :best
    remove_index :answers, %i[question_id best]
  end
end
