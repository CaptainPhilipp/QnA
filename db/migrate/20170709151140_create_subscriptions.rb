class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.references :question, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.index %i[question_id user_id]

      t.timestamps
    end
  end
end
