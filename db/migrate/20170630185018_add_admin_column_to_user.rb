class AddAdminColumnToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :admin, :boolean, nul: false, default: false
  end
end
