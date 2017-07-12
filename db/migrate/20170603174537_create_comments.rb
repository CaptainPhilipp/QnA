# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true, null: false
      t.references :commentable, polymorphic: true, null: false
      t.column :body, :string, null: false

      t.timestamps
    end
  end
end
