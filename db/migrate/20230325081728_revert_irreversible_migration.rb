class RevertIrreversibleMigration < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :email, :string
  end
end
