class IrreversibleMigrationExample < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :email, :text
  end
end
