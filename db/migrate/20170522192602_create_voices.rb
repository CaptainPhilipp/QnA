class CreateVoices < ActiveRecord::Migration[5.0]
  def change
    create_table :voices do |t|
      t.references :user, foreign_key: true, null: false
      t.references :rateable, null: false, polymotphic: true
      t.column :value, :integer

      t.timestamps
    end
  end
end
