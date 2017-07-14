class AddDeltaToSearchableModels < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :delta, :boolean, default: true, null: false
    add_column :answers  , :delta, :boolean, default: true, null: false
    add_column :comments , :delta, :boolean, default: true, null: false
    add_column :users    , :delta, :boolean, default: true, null: false
  end
end
