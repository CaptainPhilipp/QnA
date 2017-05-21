class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.references :attachable, polymorphic: true # index прописывается правильно
      t.column :file, :string, null: false

      t.timestamps
    end
  end
end
