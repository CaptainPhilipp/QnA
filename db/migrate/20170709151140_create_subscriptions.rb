class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def up
    create_table :subscriptions do |t|
      t.references :question, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.boolean :instant, index: true, null: false, default: true

      t.timestamps
    end
  end

  def down
    drop_table :subscriptions
  end
end
